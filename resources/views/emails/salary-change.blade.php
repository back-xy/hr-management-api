@if ($isForEmployee)
    Hello {{ $employee->name }},

    We are pleased to inform you that your salary has been updated.

    Previous Salary: {{ number_format($oldSalary, 0) }} IQD
    New Salary: {{ number_format($newSalary, 0) }} IQD
    {{ $isIncrease ? 'Increase' : 'Decrease' }}: {{ $isIncrease ? '+' : '' }}{{ number_format(abs($difference), 0) }}
    IQD ({{ $isIncrease ? '+' : '' }}{{ $percentChange }}%)

    This change is effective immediately.

    If you have any questions regarding this salary adjustment, please contact HR or your direct manager.

    Thank you for your continued dedication and hard work.

    Best regards,
    HR Team
@else
    Salary Update Notification

    This is to notify you that one of your team members has received a salary adjustment.

    Employee Details:
    - Name: {{ $employee->name }}
    - Email: {{ $employee->email }}
    - Position: {{ $employee->position ? $employee->position->name : 'N/A' }}
    - Hire Date: {{ $employee->hire_date ? $employee->hire_date->format('F j, Y') : 'N/A' }}

    Salary Details:
    - Previous Salary: {{ number_format($oldSalary, 0) }} IQD
    - New Salary: {{ number_format($newSalary, 0) }} IQD
    - {{ $isIncrease ? 'Increase' : 'Decrease' }}:
    {{ $isIncrease ? '+' : '' }}{{ number_format(abs($difference), 0) }} IQD
    ({{ $isIncrease ? '+' : '' }}{{ $percentChange }}%)

    This change has been processed and is effective immediately.

    For any questions or concerns regarding this salary adjustment, please contact the HR department.

    Best regards,
    HR System
@endif
