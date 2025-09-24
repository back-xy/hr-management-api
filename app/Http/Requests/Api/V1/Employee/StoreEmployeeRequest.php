<?php

namespace App\Http\Requests\Api\V1\Employee;

use App\Rules\UniqueFounder;
use Illuminate\Foundation\Http\FormRequest;

class StoreEmployeeRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:employees,email',
            'salary' => 'required|numeric|min:0',
            'position_id' => 'nullable|exists:employee_positions,id',
            'manager_id' => [
                'required_unless:is_founder,true',
                'prohibited_if:is_founder,true',
                'exists:employees,id',
            ],
            'is_founder' => [
                'sometimes',
                'boolean',
                new UniqueFounder(),
            ],
            'hire_date' => 'required|date',
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:500',
            'status' => 'sometimes|in:active,inactive,terminated',
        ];
    }
}
