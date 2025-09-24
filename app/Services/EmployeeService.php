<?php

namespace App\Services;

use App\Models\Employee;
use App\Mail\SalaryChangeNotification;
use App\Mail\NewEmployeeNotification;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\StreamedResponse;

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
        $data['last_salary_change'] = now();

        $employee = Employee::create($data);
        $employee->load(['position', 'manager']);

        // Send notification to manager
        if ($employee->manager) {
            Mail::to($employee->manager->email)->queue(
                new NewEmployeeNotification($employee)
            );
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
        // Store the original salary for comparison
        $originalSalary = $employee->salary;
        $salaryChanged = false;

        $employee->fill($data);

        if ($employee->isDirty('salary')) {
            $salaryChanged = true;
            $data['last_salary_change'] = now();
            $employee->last_salary_change = now();
        }

        $employee->save();
        $employee->refresh();
        $employee->load(['position', 'manager']);

        // Send salary change email notifications if salary was updated
        if ($salaryChanged) {
            $this->sendSalaryChangeEmails($employee, $originalSalary, $employee->salary);
        }

        return $employee;
    }

    /**
     * Send salary change email notifications
     */
    private function sendSalaryChangeEmails(Employee $employee, int $oldSalary, int $newSalary): void
    {
        // Send email to the employee about their salary change
        Mail::to($employee->email)->queue(
            new SalaryChangeNotification($employee, $oldSalary, $newSalary, true)
        );

        // Get the management hierarchy and send email to each manager
        $managers = $employee->getManagerHierarchy();

        foreach ($managers as $manager) {
            Mail::to($manager->email)->queue(
                new SalaryChangeNotification($employee, $oldSalary, $newSalary, false)
            );
        }
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

    /**
     * Export all employee data to CSV format
     */
    public function exportToCsv(): StreamedResponse
    {
        $employees = Employee::with(['position', 'manager'])
            ->withTrashed()
            ->get();

        $filename = 'employees_export_' . now()->format('Y_m_d_His') . '.csv';

        // Log the export operation
        Log::channel('employee')->info('Employee data exported to CSV', [
            'user_id' => Auth::id(),
            'user_name' => Auth::user()?->name ?? 'System',
            'total_records' => $employees->count(),
            'filename' => $filename,
            'timestamp' => now()->toDateTimeString(),
        ]);

        $headers = [
            'Content-Type' => 'text/csv',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ];

        $callback = function () use ($employees) {
            $file = fopen('php://output', 'w');

            // CSV Headers
            fputcsv($file, [
                'ID',
                'Name',
                'Email',
                'Salary',
                'Position',
                'Manager ID',
                'Manager Name',
                'Hire Date',
                'Last Salary Change',
                'Is Founder',
                'Deleted At',
                'Created At',
                'Updated At'
            ]);

            // CSV Data
            foreach ($employees as $employee) {
                fputcsv($file, [
                    $employee->id,
                    $employee->name,
                    $employee->email,
                    number_format($employee->salary) . ' IQD',
                    $employee->position?->title ?? '',
                    $employee->manager_id ?? '',
                    $employee->manager?->name ?? '',
                    $employee->hire_date ? date('d/m/Y', strtotime($employee->hire_date)) : '',
                    $employee->last_salary_change ? $employee->last_salary_change->format('d/m/Y h:i A') : '',
                    $employee->is_founder ? '1' : '0',
                    $employee->created_at->format('d/m/Y h:i A'),
                    $employee->updated_at->format('d/m/Y h:i A'),
                    $employee->deleted_at ? $employee->deleted_at->format('d/m/Y h:i A') : '',
                ]);
            }

            fclose($file);
        };

        return response()->stream($callback, 200, $headers);
    }
}
