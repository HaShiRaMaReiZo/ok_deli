<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Package;
use App\Models\Rider;
use App\Models\User;
use App\Models\Merchant;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class OfficeController extends Controller
{
    // Middleware is handled in routes/web.php
    // Role check is done in each method if needed

    public function dashboard()
    {
        // Verify user has office role (auth middleware already checked in routes)
        $user = auth()->user();
        $officeRoles = ['super_admin', 'office_manager', 'office_staff'];
        if (!in_array($user->role, $officeRoles)) {
            abort(403, 'Access denied');
        }
        
        try {
            // Statistics
            $stats = [
                'total_packages' => Package::count(),
                'pending_packages' => Package::where('status', 'registered')->count(),
                'in_transit' => Package::whereIn('status', ['assigned_to_rider', 'picked_up', 'on_the_way'])->count(),
                'delivered_today' => Package::where('status', 'delivered')
                    ->whereDate('updated_at', today())
                    ->count(),
                'active_riders' => Rider::where('status', '!=', 'offline')->count(),
                'total_riders' => Rider::count(),
                'total_merchants' => Merchant::count(),
            ];

            // Recent packages - use optional relationships to avoid errors
            $recentPackages = Package::with(['merchant', 'currentRider'])
                ->orderBy('created_at', 'desc')
                ->limit(10)
                ->get();

            // Packages by status
            $packagesByStatus = Package::selectRaw('status, count(*) as count')
                ->groupBy('status')
                ->pluck('count', 'status')
                ->toArray();

            return view('office.dashboard', compact('stats', 'recentPackages', 'packagesByStatus'));
        } catch (\Exception $e) {
            // Log the error and show a friendly message
            Log::error('Dashboard error: ' . $e->getMessage());
            return view('office.dashboard', [
                'stats' => [
                    'total_packages' => 0,
                    'pending_packages' => 0,
                    'in_transit' => 0,
                    'delivered_today' => 0,
                    'active_riders' => 0,
                    'total_riders' => 0,
                    'total_merchants' => 0,
                ],
                'recentPackages' => collect([]),
                'packagesByStatus' => [],
                'error' => 'Unable to load dashboard data. Please check database connection.',
            ]);
        }
    }

    public function packages(Request $request)
    {
        // Verify user has office role (auth middleware already checked in routes)
        $user = auth()->user();
        $officeRoles = ['super_admin', 'office_manager', 'office_staff'];
        if (!in_array($user->role, $officeRoles)) {
            abort(403, 'Access denied');
        }
        
        $query = Package::with(['merchant', 'currentRider', 'statusHistory']);

        // Filters
        if ($request->has('merchant_id') && $request->merchant_id) {
            $query->where('merchant_id', $request->merchant_id);
        }

        if ($request->has('status') && $request->status) {
            $query->where('status', $request->status);
        }

        if ($request->has('tracking_code') && $request->tracking_code) {
            $query->where('tracking_code', 'like', '%' . $request->tracking_code . '%');
        }

        if ($request->has('date_from') && $request->date_from) {
            $query->whereDate('created_at', '>=', $request->date_from);
        }

        if ($request->has('date_to') && $request->date_to) {
            $query->whereDate('created_at', '<=', $request->date_to);
        }

        $packages = $query->orderBy('created_at', 'desc')->paginate(20);
        $merchants = Merchant::orderBy('business_name')->get();
        $riders = Rider::orderBy('name')->get();

        $statuses = [
            'registered' => 'Registered',
            'arrived_at_office' => 'Arrived at Office',
            'assigned_to_rider' => 'Assigned to Rider',
            'picked_up' => 'Picked Up',
            'on_the_way' => 'On the Way',
            'delivered' => 'Delivered',
            'returned_to_office' => 'Returned to Office',
            'cancelled' => 'Cancelled',
        ];

        $apiToken = $this->getApiToken();
        return view('office.packages', compact('packages', 'merchants', 'riders', 'statuses', 'apiToken'));
    }

    public function riders(Request $request)
    {
        $query = Rider::with(['user', 'zone']);

        if ($request->has('status') && $request->status) {
            $query->where('status', $request->status);
        }

        $riders = $query->orderBy('name', 'asc')->get();

        // Add package count for each rider
        $riders->map(function ($rider) {
            $rider->package_count = Package::where('current_rider_id', $rider->id)
                ->whereIn('status', ['assigned_to_rider', 'picked_up', 'on_the_way'])
                ->count();
            return $rider;
        });

        $apiToken = $this->getApiToken();
        return view('office.riders', compact('riders', 'apiToken'));
    }

    public function map()
    {
        $apiToken = $this->getApiToken();
        return view('office.map', compact('apiToken'));
    }

    protected function getApiToken()
    {
        $user = auth()->user();
        // Get or create a token for web API calls
        $token = $user->tokens()->where('name', 'web-session')->first();
        if (!$token) {
            $token = $user->createToken('web-session');
        }
        return $token->plainTextToken ?? $token->token;
    }
}

