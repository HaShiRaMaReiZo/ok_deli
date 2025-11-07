<?php

namespace App\Http\Controllers\Api\Merchant;

use App\Http\Controllers\Controller;
use App\Models\Package;
use App\Models\PackageStatusHistory;
use App\Services\TrackingCodeService;
use App\Events\PackageStatusChanged;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PackageController extends Controller
{
    public function index(Request $request)
    {
        $merchant = $request->user()->merchant;
        
        $packages = Package::where('merchant_id', $merchant->id)
            ->with(['currentRider', 'statusHistory'])
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        return response()->json($packages);
    }

    public function store(Request $request)
    {
        $request->validate([
            'customer_name' => 'required|string|max:255',
            'customer_phone' => 'required|string|max:20',
            'customer_email' => 'nullable|email',
            'delivery_address' => 'required|string',
            'delivery_latitude' => 'nullable|numeric',
            'delivery_longitude' => 'nullable|numeric',
            'payment_type' => 'required|in:cod,prepaid',
            'amount' => 'required|numeric|min:0',
            'package_image' => 'nullable|image|max:2048',
            'package_description' => 'nullable|string',
        ]);

        $merchant = $request->user()->merchant;

        // Generate unique tracking code
        $trackingCode = TrackingCodeService::generate();

        // Handle image upload
        $imagePath = null;
        if ($request->hasFile('package_image')) {
            $imagePath = $request->file('package_image')->store('packages', 'public');
        }

        $package = Package::create([
            'tracking_code' => $trackingCode,
            'merchant_id' => $merchant->id,
            'customer_name' => $request->customer_name,
            'customer_phone' => $request->customer_phone,
            'customer_email' => $request->customer_email,
            'delivery_address' => $request->delivery_address,
            'delivery_latitude' => $request->delivery_latitude,
            'delivery_longitude' => $request->delivery_longitude,
            'payment_type' => $request->payment_type,
            'amount' => $request->amount,
            'package_image' => $imagePath,
            'package_description' => $request->package_description,
            'status' => 'registered',
        ]);

        // Log status history
        PackageStatusHistory::create([
            'package_id' => $package->id,
            'status' => 'registered',
            'changed_by_user_id' => $request->user()->id,
            'changed_by_type' => 'merchant',
            'created_at' => now(),
        ]);

        // Broadcast status change via WebSocket
        event(new PackageStatusChanged($package->id, 'registered', $package->merchant_id));

        return response()->json([
            'message' => 'Package created successfully',
            'package' => $package->load(['merchant', 'statusHistory']),
        ], 201);
    }

    public function show(Request $request, $id)
    {
        $merchant = $request->user()->merchant;
        
        $package = Package::where('merchant_id', $merchant->id)
            ->with(['merchant', 'currentRider', 'statusHistory', 'deliveryProof', 'codCollection'])
            ->findOrFail($id);

        return response()->json($package);
    }

    public function track(Request $request, $id)
    {
        $merchant = $request->user()->merchant;
        
        $package = Package::where('merchant_id', $merchant->id)
            ->with(['currentRider', 'statusHistory'])
            ->findOrFail($id);

        return response()->json([
            'package' => $package,
            'status_history' => $package->statusHistory()->orderBy('created_at', 'desc')->get(),
        ]);
    }

    public function liveLocation(Request $request, $id)
    {
        $merchant = $request->user()->merchant;
        
        $package = Package::where('merchant_id', $merchant->id)
            ->with('currentRider')
            ->findOrFail($id);

        // Only return location if status is on_the_way
        if ($package->status !== 'on_the_way') {
            return response()->json([
                'message' => 'Package is not on the way',
                'location' => null,
            ]);
        }

        $rider = $package->currentRider;
        
        if (!$rider) {
            return response()->json([
                'message' => 'No rider assigned',
                'location' => null,
            ]);
        }

        return response()->json([
            'rider' => [
                'id' => $rider->id,
                'name' => $rider->name,
                'latitude' => $rider->current_latitude,
                'longitude' => $rider->current_longitude,
                'last_update' => $rider->last_location_update,
            ],
            'package' => [
                'id' => $package->id,
                'tracking_code' => $package->tracking_code,
                'status' => $package->status,
                'delivery_address' => $package->delivery_address,
                'delivery_latitude' => $package->delivery_latitude,
                'delivery_longitude' => $package->delivery_longitude,
            ],
        ]);
    }

    public function history(Request $request, $id)
    {
        $merchant = $request->user()->merchant;
        
        $package = Package::where('merchant_id', $merchant->id)
            ->findOrFail($id);

        $history = PackageStatusHistory::where('package_id', $package->id)
            ->with('changedBy')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($history);
    }
}
