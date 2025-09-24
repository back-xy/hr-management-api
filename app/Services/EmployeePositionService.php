<?php

namespace App\Services;

use App\Models\EmployeePosition;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\JsonResponse;

class EmployeePositionService
{
    /**
     * Get paginated employee positions with employee count
     */
    public function getPaginated(int $perPage = 15): LengthAwarePaginator
    {
        return EmployeePosition::withCount('employees')->latest()->paginate($perPage);
    }

    /**
     * Create a new employee position
     */
    public function create(array $data): EmployeePosition
    {
        return EmployeePosition::create($data);
    }

    /**
     * Get an employee position with its employees
     */
    public function getWithEmployees(EmployeePosition $employeePosition): EmployeePosition
    {
        return $employeePosition->load('employees');
    }

    /**
     * Update an employee position
     */
    public function update(EmployeePosition $employeePosition, array $data): EmployeePosition
    {
        $employeePosition->update($data);
        return $employeePosition->fresh();
    }

    /**
     * Delete an employee position
     */
    public function delete(EmployeePosition $employeePosition): bool
    {
        // Check if position has employees
        if ($employeePosition->employees()->exists()) {
            throw new HttpResponseException(
                new JsonResponse([
                    'message' => 'Cannot delete employee position that has employees assigned',
                    'error' => 'Position is in use'
                ], 422)
            );
        }

        return $employeePosition->delete();
    }
}
