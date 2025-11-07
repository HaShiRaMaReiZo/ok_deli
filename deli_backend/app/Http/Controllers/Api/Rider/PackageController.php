<?php

namespace App\Http\Controllers\Api\Rider;

use App\Http\Controllers\Controller;
use App\Models\Package;
use App\Models\PackageStatusHistory;
use App\Models\RiderAssignment;
use App\Models\DeliveryProof;
use App\Models\CodCollection;
use App\Events\PackageStatusChanged;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PackageController extends Controller
{
    public function index(Request $request)
    {
        $rider = $request->user()->rider;
        
        $packages = Package::where('current_rider_id', $rider->id)
            ->with(['merchant', 'statusHistory'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($packages);
    }

    public function show(Request $request, $id)
    {
        $rider = $request->user()->rider;
        
        $package = Package::where('current_rider_id', $rider->id)
            ->with(['merchant', 'statusHistory', 'deliveryProof', 'codCollection'])
            ->findOrFail($id);

        return response()->json($package);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:picked_up,on_the_way,delivered,contact_failed,return_to_office',
            'notes' => 'nullable|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ]);

        $rider = $request->user()->rider;
        
        $package = Package::where('current_rider_id', $rider->id)
            ->findOrFail($id);

        $oldStatus = $package->status;
        $newStatus = $request->status;

        // Update package status
        $package->status = $newStatus;
        
        // Update timestamps based on status
        if ($newStatus === 'picked_up' && !$package->picked_up_at) {
            $package->picked_up_at = now();
        } elseif ($newStatus === 'delivered' && !$package->delivered_at) {
            $package->delivered_at = now();
        }

        $package->delivery_notes = $request->notes;
        $package->save();

        // Log status history
        PackageStatusHistory::create([
            'package_id' => $package->id,
            'status' => $newStatus,
            'changed_by_user_id' => $request->user()->id,
            'changed_by_type' => 'rider',
            'notes' => $request->notes,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'created_at' => now(),
        ]);

        // Broadcast status change via WebSocket
        event(new PackageStatusChanged($package->id, $newStatus, $package->merchant_id));

        return response()->json([
            'message' => 'Status updated successfully',
            'package' => $package->load(['merchant', 'statusHistory']),
        ]);
    }

    public function startDelivery(Request $request, $id)
    {
        $rider = $request->user()->rider;
        
        $package = Package::where('current_rider_id', $rider->id)
            ->findOrFail($id);

        if ($package->status !== 'picked_up') {
            return response()->json([
                'message' => 'Package must be picked up first',
            ], 400);
        }

        // Update status to on_the_way
        $package->status = 'on_the_way';
        $package->save();

        // Log status history
        PackageStatusHistory::create([
            'package_id' => $package->id,
            'status' => 'on_the_way',
            'changed_by_user_id' => $request->user()->id,
            'changed_by_type' => 'rider',
            'notes' => 'Rider started delivery',
            'created_at' => now(),
        ]);

        // Update rider status to busy
        $rider->status = 'busy';
        $rider->save();

        // Broadcast status change via WebSocket
        event(new PackageStatusChanged($package->id, 'on_the_way', $package->merchant_id));

        return response()->json([
            'message' => 'Delivery started successfully',
            'package' => $package->load(['merchant', 'statusHistory']),
        ]);
    }

    public function contactCustomer(Request $request, $id)
    {
        $request->validate([
            'contact_result' => 'required|in:success,failed',
            'notes' => 'nullable|string',
        ]);

        $rider = $request->user()->rider;
        
        $package = Package::where('current_rider_id', $rider->id)
            ->findOrFail($id);

        if ($request->contact_result === 'failed') {
            $package->status = 'contact_failed';
            $package->delivery_notes = $request->notes;
            $package->save();

            // Log status history
            PackageStatusHistory::create([
                'package_id' => $package->id,
                'status' => 'contact_failed',
                'changed_by_user_id' => $request->user()->id,
                'changed_by_type' => 'rider',
                'notes' => $request->notes ?? 'Customer contact failed',
                'created_at' => now(),
            ]);
        }

        return response()->json([
            'message' => 'Contact result recorded',
            'package' => $package->load(['merchant', 'statusHistory']),
        ]);
    }

    public function uploadProof(Request $request, $id)
    {
        $request->validate([
            'proof_type' => 'required|in:photo,signature',
            'proof_data' => 'required',
            'delivery_latitude' => 'nullable|numeric',
            'delivery_longitude' => 'nullable|numeric',
            'delivered_to_name' => 'nullable|string',
            'delivered_to_phone' => 'nullable|string',
            'notes' => 'nullable|string',
        ]);

        $rider = $request->user()->rider;
        
        $package = Package::where('current_rider_id', $rider->id)
            ->findOrFail($id);

        // Handle proof upload
        $proofData = $request->proof_data;
        if ($request->proof_type === 'photo' && $request->hasFile('proof_data')) {
            $proofData = $request->file('proof_data')->store('delivery_proofs', 'public');
        }

        DeliveryProof::create([
            'package_id' => $package->id,
            'rider_id' => $rider->id,
            'proof_type' => $request->proof_type,
            'proof_data' => $proofData,
            'delivery_latitude' => $request->delivery_latitude,
            'delivery_longitude' => $request->delivery_longitude,
            'delivered_to_name' => $request->delivered_to_name,
            'delivered_to_phone' => $request->delivered_to_phone,
            'notes' => $request->notes,
            'created_at' => now(),
        ]);

        return response()->json([
            'message' => 'Delivery proof uploaded successfully',
        ]);
    }

    public function collectCod(Request $request, $id)
    {
        $request->validate([
            'amount' => 'required|numeric|min:0',
            'collection_proof' => 'nullable|image|max:2048',
        ]);

        $rider = $request->user()->rider;
        
        $package = Package::where('current_rider_id', $rider->id)
            ->findOrFail($id);

        if ($package->payment_type !== 'cod') {
            return response()->json([
                'message' => 'Package is not COD',
            ], 400);
        }

        // Handle collection proof upload
        $collectionProof = null;
        if ($request->hasFile('collection_proof')) {
            $collectionProof = $request->file('collection_proof')->store('cod_proofs', 'public');
        }

        CodCollection::create([
            'package_id' => $package->id,
            'rider_id' => $rider->id,
            'amount' => $request->amount,
            'collected_at' => now(),
            'collection_proof' => $collectionProof,
            'status' => 'collected',
        ]);

        return response()->json([
            'message' => 'COD collected successfully',
        ]);
    }
}
