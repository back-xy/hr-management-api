<?php

namespace App\Http\Requests\Api\V1\Employee;

use App\Rules\UniqueFounder;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateEmployeeRequest extends FormRequest
{
    public function rules(): array
    {
        $employeeId = request()->route('employee')->id;

        return [
            'name' => 'sometimes|string|max:255',
            'email' => [
                'sometimes',
                'email',
                Rule::unique('employees')->ignore($employeeId),
            ],
            'salary' => 'sometimes|numeric|min:0',
            'position_id' => 'nullable|exists:employee_positions,id',
            'manager_id' => [
                'sometimes',
                'nullable',
                'required_unless:is_founder,true',
                'prohibited_if:is_founder,true',
                Rule::exists('employees', 'id')->whereNot('id', $employeeId),
            ],
            'is_founder' => [
                'sometimes',
                'boolean',
                new UniqueFounder($employeeId),
            ],
            'hire_date' => 'sometimes|date',
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:500',
            'status' => 'sometimes|in:active,inactive,terminated',
        ];
    }
}
