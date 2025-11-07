<?php

namespace App\Http\Controllers\Api\Office;

use App\Http\Controllers\Controller;
use App\Models\Rider;
use Illuminate\Http\Request;

class RiderController extends Controller
{
    public function index(Request $request)
    {
        $query = Rider::with(['user', 'zone']);

        // Filters
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('zone_id')) {
            $query->where('zone_id', $request->zone_id);
        }

        $riders = $query->orderBy('name', 'asc')->get();

        // Add package count for each rider
        $riders->map(function ($rider) {
            $rider->package_count = \App\Models\Package::where('current_rider_id', $rider->id)
                ->whereIn('status', ['assigned_to_rider', 'picked_up', 'on_the_way'])
                ->count();
            return $rider;
        });

        return response()->json($riders);
    }

    public function show($id)
    {
        $rider = Rider::with(['user', 'zone', 'packages' => function ($query) {
            $query->whereIn('status', ['assigned_to_rider', 'picked_up', 'on_the_way']);
        }])->findOrFail($id);

        return response()->json($rider);
    }

    public function locations(Request $request)
    {
        // Get all active riders with their current locations
        $riders = Rider::whereNotNull('current_latitude')
            ->whereNotNull('current_longitude')
            ->where('status', '!=', 'offline')
            ->with(['user', 'zone'])
            ->get();

        $locations = $riders->map(function ($rider) {
            return [
                'rider_id' => $rider->id,
                'name' => $rider->name,
                'phone' => $rider->phone,
                'status' => $rider->status,
                'latitude' => $rider->current_latitude,
                'longitude' => $rider->current_longitude,
                'last_location_update' => $rider->last_location_update,
                'package_count' => \App\Models\Package::where('current_rider_id', $rider->id)
                    ->whereIn('status', ['assigned_to_rider', 'picked_up', 'on_the_way'])
                    ->count(),
            ];
        });

        return response()->json([
            'riders' => $locations,
        ]);
    }
}
