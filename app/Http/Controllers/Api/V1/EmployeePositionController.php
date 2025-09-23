<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\V1\EmployeePosition\StoreEmployeePositionRequest;
use App\Http\Requests\Api\V1\EmployeePosition\UpdateEmployeePositionRequest;
use App\Models\EmployeePosition;
use App\Services\EmployeePositionService;
use Illuminate\Http\JsonResponse;

class EmployeePositionController extends Controller
{
    public function __construct(
        private readonly EmployeePositionService $employeePositionService
    ) {}

    /**
     * Display a listing of employee positions
     */
    public function index(): JsonResponse
    {
        $positions = $this->employeePositionService->getPaginated();

        return response()->json([
            'data' => $positions
        ]);
    }

    /**
     * Store a newly created employee position
     */
    public function store(StoreEmployeePositionRequest $request): JsonResponse
    {
        $position = $this->employeePositionService->create($request->validated());

        return response()->json([
            'message' => 'Employee position created successfully',
            'data' => $position
        ], 201);
    }

    /**
     * Display the specified employee position
     */
    public function show(EmployeePosition $employeePosition): JsonResponse
    {
        $position = $this->employeePositionService->getWithEmployees($employeePosition);

        return response()->json([
            'data' => $position
        ]);
    }

    /**
     * Update the specified employee position
     */
    public function update(UpdateEmployeePositionRequest $request, EmployeePosition $employeePosition): JsonResponse
    {
        $position = $this->employeePositionService->update($employeePosition, $request->validated());

        return response()->json([
            'message' => 'Employee position updated successfully',
            'data' => $position
        ]);
    }

    /**
     * Remove the specified employee position
     */
    public function destroy(EmployeePosition $employeePosition): JsonResponse
    {
        $this->employeePositionService->delete($employeePosition);

        return response()->json([
            'message' => 'Employee position deleted successfully'
        ]);
    }
}
