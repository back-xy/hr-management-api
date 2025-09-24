<?php

namespace App\Http\Requests\Api\V1\Employee;

use Illuminate\Foundation\Http\FormRequest;

/**
 * @method string|null input(string $key, mixed $default = null)
 */
class EmployeeIndexRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'name' => 'nullable|string|max:255',
            'min_salary' => 'nullable|numeric|min:0',
            'max_salary' => 'nullable|numeric|min:0',
            'per_page' => 'nullable|integer|min:5|max:100',
        ];
    }

    public function getFilters(): array
    {
        return array_filter([
            'name' => $this->input('name'),
            'min_salary' => $this->input('min_salary'),
            'max_salary' => $this->input('max_salary'),
        ]);
    }
}
