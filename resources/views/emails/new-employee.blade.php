New Employee Notification

A new employee has been added to your team.

Employee Details:
- Name: {{ $employee->name }}
- Email: {{ $employee->email }}
- Position: {{ $employee->position ? $employee->position->name : 'N/A' }}
- Salary: {{ number_format($employee->salary, 0) }} IQD
- Hire Date: {{ $employee->hire_date ? $employee->hire_date->format('F j, Y') : 'N/A' }}

Please reach out to welcome them to the team and ensure they have everything they need to get started.

If you have any questions about this new team member, please contact the HR department.

Best regards,
HR System
