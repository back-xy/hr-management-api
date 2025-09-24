<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\EmployeeController;
use App\Http\Controllers\Api\V1\EmployeePositionController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// API Version 1
Route::prefix('v1')->group(function () {

    Route::get('health', function () {
        return response()->json([
            'status' => 'OK',
            'message' => 'HR Management API is running',
            'version' => 'v1.0.0',
            'timestamp' => now()->toDateTimeString(),
        ]);
    });

    // Authentication Routes
    Route::prefix('auth')->group(function () {
        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);
        Route::post('logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
    });

    // Protected Routes
    Route::middleware(['auth:sanctum', 'throttle:10,1'])->group(function () {

        // Employee Routes
        Route::prefix('employees')->group(function () {
            Route::get('/', [EmployeeController::class, 'index']);
            Route::post('/', [EmployeeController::class, 'store']);
            Route::get('/{employee}', [EmployeeController::class, 'show']);
            Route::put('/{employee}', [EmployeeController::class, 'update']);
            Route::delete('/{employee}', [EmployeeController::class, 'destroy']);

            // Hierarchy Routes
            Route::get('/{employee}/hierarchy', [EmployeeController::class, 'getHierarchy']);
            Route::get('/{employee}/hierarchy-with-salaries', [EmployeeController::class, 'getHierarchyWithSalaries']);

            // Search Route
            Route::get('/search', [EmployeeController::class, 'search']);

            // Export/Import Routes
            Route::get('/export/csv', [EmployeeController::class, 'exportCsv']);
            Route::post('/import/csv', [EmployeeController::class, 'importCsv']);
            Route::get('/export/json', [EmployeeController::class, 'exportJson']);

            // Salary Change History
            Route::get('/no-salary-change/{months}', [EmployeeController::class, 'employeesWithoutSalaryChange']);
        });

        // Employee Position Routes
        Route::apiResource('employee-positions', EmployeePositionController::class);
    });
});
