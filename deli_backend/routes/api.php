<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\Merchant\PackageController as MerchantPackageController;
use App\Http\Controllers\Api\Rider\PackageController as RiderPackageController;
use App\Http\Controllers\Api\Rider\LocationController as RiderLocationController;
use App\Http\Controllers\Api\Office\PackageController as OfficePackageController;
use App\Http\Controllers\Api\Office\RiderController as OfficeRiderController;

// Public routes
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // Auth routes
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/user', [AuthController::class, 'user']);

    // Merchant routes
    Route::prefix('merchant')->middleware('role:merchant')->group(function () {
        Route::get('/packages', [MerchantPackageController::class, 'index']);
        Route::post('/packages', [MerchantPackageController::class, 'store']);
        Route::get('/packages/{id}', [MerchantPackageController::class, 'show']);
        Route::get('/packages/{id}/track', [MerchantPackageController::class, 'track']);
        Route::get('/packages/{id}/live-location', [MerchantPackageController::class, 'liveLocation']);
        Route::get('/packages/{id}/history', [MerchantPackageController::class, 'history']);
    });

    // Rider routes
    Route::prefix('rider')->middleware('role:rider')->group(function () {
        Route::get('/packages', [RiderPackageController::class, 'index']);
        Route::get('/packages/{id}', [RiderPackageController::class, 'show']);
        Route::put('/packages/{id}/status', [RiderPackageController::class, 'updateStatus']);
        Route::post('/packages/{id}/start-delivery', [RiderPackageController::class, 'startDelivery']);
        Route::post('/packages/{id}/contact-customer', [RiderPackageController::class, 'contactCustomer']);
        Route::post('/packages/{id}/proof', [RiderPackageController::class, 'uploadProof']);
        Route::post('/packages/{id}/cod', [RiderPackageController::class, 'collectCod']);
        
        // Location routes
        Route::post('/location', [RiderLocationController::class, 'update']);
        Route::get('/location', [RiderLocationController::class, 'current']);
    });

    // Office routes
    Route::prefix('office')->middleware('role:office_manager,office_staff,super_admin')->group(function () {
        // Package routes
        Route::get('/packages', [OfficePackageController::class, 'index']);
        Route::get('/packages/{id}', [OfficePackageController::class, 'show']);
        Route::put('/packages/{id}/status', [OfficePackageController::class, 'updateStatus']);
        Route::post('/packages/{id}/assign', [OfficePackageController::class, 'assign']);
        Route::post('/packages/bulk-assign', [OfficePackageController::class, 'bulkAssign']);
        Route::get('/packages/arrived', [OfficePackageController::class, 'arrived']);
        
        // Rider routes
        Route::get('/riders', [OfficeRiderController::class, 'index']);
        Route::get('/riders/{id}', [OfficeRiderController::class, 'show']);
        Route::get('/riders/locations', [OfficeRiderController::class, 'locations']);
    });
});

