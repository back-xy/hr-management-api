<?php

namespace App\Services;

use App\Models\Employee;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Http\Exceptions\HttpResponseException;

class EmployeeService
{
    /**
     * Get paginated employees with filtering
     */
    public function getPaginated(int $perPage = 15, array $filters = []): LengthAwarePaginator
    {
        $query = Employee::with(['position', 'manager'])->latest();

        // Apply search filters
        if (!empty($filters['name'])) {
            $query->where('name', 'like', "%{$filters['name']}%");
        }

        if (!empty($filters['min_salary'])) {
            $query->where('salary', '>=', $filters['min_salary']);
        }

        if (!empty($filters['max_salary'])) {
            $query->where('salary', '<=', $filters['max_salary']);
        }

        return $query->paginate($perPage);
    }

    /**
     * Create a new employee
     */
    public function create(array $data): Employee
    {
        // Set initial values
        $data['last_salary_change'] = now();

        $employee = Employee::create($data);
        $employee->load(['position', 'manager']);

        // Send notification to manager
        if ($employee->manager) {
            // TODO: Implement manager notification
            // Mail::to($employee->manager->email)->send(new NewEmployeeNotification($employee));
        }

        return $employee;
    }

    /**
     * Get an employee with relationships
     */
    public function getWithRelationships(Employee $employee): Employee
    {
        return $employee->load(['position', 'manager', 'subordinates']);
    }

    /**
     * Update an employee
     */
    public function update(Employee $employee, array $data): Employee
    {
        $employee->fill($data);

        if ($employee->isDirty('salary')) {
            $data['last_salary_change'] = now();
            $employee->last_salary_change = now();
        }

        $employee->save();
        return $employee->fresh()->load(['position', 'manager']);
    }

    /**
     * Delete an employee (soft delete)
     */
    public function delete(Employee $employee): bool
    {
        // Cannot delete the founder
        if ($employee->is_founder) {
            throw new HttpResponseException(
                response()->json(['message' => 'Cannot delete the company founder'], 422)
            );
        }

        // Reassign subordinates before deletion
        if ($employee->subordinates()->count() > 0) {
            throw new HttpResponseException(
                response()->json([
                    'message' => 'Cannot delete employee with subordinates. Please reassign their subordinates first.',
                    'subordinates_count' => $employee->subordinates()->count()
                ], 422)
            );
        }

        // Perform soft delete
        return $employee->delete();
    }

    /**
     * Get manager hierarchy names for an employee
     */
    public function getHierarchyNames(Employee $employee): array
    {
        return $employee->getManagerHierarchyNames();
    }

    /**
     * Get manager hierarchy with salaries for an employee
     */
    public function getHierarchyWithSalaries(Employee $employee): array
    {
        return $employee->getManagerHierarchyWithSalaries();
    }

    /**
     * Get employees without salary change in specified months
     */
    public function getWithoutSalaryChange(int $months, int $perPage = 15): LengthAwarePaginator
    {
        return Employee::withoutSalaryChangeInMonths($months)
            ->with(['position', 'manager'])
            ->paginate($perPage);
    }
}
