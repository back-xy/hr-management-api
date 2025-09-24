<?php

namespace App\Observers;

use App\Models\Employee;
use App\Models\EmployeeLog;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\Facades\Log;

class EmployeeObserver
{
    /**
     * Handle the Employee "created" event.
     */
    public function created(Employee $employee): void
    {
        $this->logAction($employee, 'created', null, $employee->toArray());
    }

    /**
     * Handle the Employee "updated" event.
     */
    public function updated(Employee $employee): void
    {
        $this->logAction($employee, 'updated', $employee->getOriginal(), $employee->getChanges());
    }

    /**
     * Handle the Employee "deleted" event.
     */
    public function deleted(Employee $employee): void
    {
        $this->logAction($employee, 'deleted', $employee->toArray(), null);
    }

    /**
     * Log employee action to database.
     */
    private function logAction(Employee $employee, string $action, ?array $oldData, ?array $newData): void
    {
        // Skip if no actual changes for updates
        if ($action === 'updated' && empty($newData)) {
            return;
        }

        // Generate description
        $userName = Auth::user()?->name ?? 'System';
        $employeeName = $employee->name ?? 'Employee';

        $description = match ($action) {
            'created' => "{$userName} created employee {$employeeName}",
            'updated' => "{$userName} updated employee {$employeeName}",
            'deleted' => "{$userName} deleted employee {$employeeName}",
            default => "{$userName} performed {$action} on employee {$employeeName}",
        };

        // Database logging
        EmployeeLog::create([
            'employee_id' => $employee->id,
            'user_id' => Auth::id(),
            'action' => $action,
            'old_data' => $oldData,
            'new_data' => $newData,
            'ip_address' => Request::ip(),
            'user_agent' => Request::userAgent(),
            'description' => $description,
        ]);

        // File logging to employee.log
        Log::channel('employee')->info($description, [
            'employee_id' => $employee->id,
            'user_id' => Auth::id(),
            'action' => $action,
            'ip_address' => Request::ip(),
            'timestamp' => now()->toDateTimeString(),
        ]);
    }
}
