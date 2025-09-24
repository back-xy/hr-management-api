<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\V1\Employee\EmployeeIndexRequest;
use App\Http\Requests\Api\V1\Employee\StoreEmployeeRequest;
use App\Http\Requests\Api\V1\Employee\UpdateEmployeeRequest;
use App\Models\Employee;
use App\Services\EmployeeService;
use Illuminate\Http\JsonResponse;

class EmployeeController extends Controller
{
    public function __construct(
        private readonly EmployeeService $employeeService
    ) {}

    /**
     * Display a listing of employees with filtering
     */
    public function index(EmployeeIndexRequest $request): JsonResponse
    {
        $employees = $this->employeeService->getPaginated(
            $request->input('per_page', 15),
            $request->getFilters()
        );

        return response()->json([
            'data' => $employees
        ]);
    }

    /**
     * Store a newly created employee
     */
    public function store(StoreEmployeeRequest $request): JsonResponse
    {
        $employee = $this->employeeService->create($request->validated());

        return response()->json([
            'data' => $employee
        ], 201);
    }

    /**
     * Display the specified employee
     */
    public function show(Employee $employee): JsonResponse
    {
        $employee = $this->employeeService->getWithRelationships($employee);

        return response()->json([
            'data' => $employee
        ]);
    }

    /**
     * Update the specified employee
     */
    public function update(UpdateEmployeeRequest $request, Employee $employee): JsonResponse
    {
        $employee = $this->employeeService->update($employee, $request->validated());

        return response()->json([
            'message' => 'Employee updated successfully',
            'data' => $employee
        ]);
    }

    /**
     * Remove the specified employee
     */
    public function destroy(Employee $employee): JsonResponse
    {
        $this->employeeService->delete($employee);

        return response()->json([
            'message' => 'Employee deleted successfully'
        ], 200);
    }

    /**
     * Get managerial hierarchy for an employee
     */
    public function getManagerialHierarchy(Employee $employee): JsonResponse
    {
        $hierarchy = $this->employeeService->getHierarchyNames($employee);

        return response()->json([
            'data' => $hierarchy
        ]);
    }

    /**
     * Get managerial hierarchy with salaries for an employee
     */
    public function getManagerialHierarchyWithSalaries(Employee $employee): JsonResponse
    {
        $hierarchy = $this->employeeService->getHierarchyWithSalaries($employee);

        return response()->json([
            'data' => $hierarchy
        ]);
    }

    /**
     * Get employees without salary change in X months
     */
    public function withoutSalaryChange(int $months): JsonResponse
    {
        $perPage = request()->input('per_page', 15);
        $employees = $this->employeeService->getWithoutSalaryChange($months, $perPage);

        return response()->json([
            'data' => $employees
        ]);
    }
}
