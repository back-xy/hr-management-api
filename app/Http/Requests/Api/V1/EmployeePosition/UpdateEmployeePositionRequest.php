<?php

namespace App\Http\Requests\Api\V1\EmployeePosition;

use Illuminate\Foundation\Http\FormRequest;

class UpdateEmployeePositionRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'title' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'min_salary' => 'nullable|numeric|min:0',
            'max_salary' => 'nullable|numeric|min:0|gte:min_salary',
            'is_active' => 'boolean',
        ];
    }
}
