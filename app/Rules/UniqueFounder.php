<?php

namespace App\Rules;

use App\Models\Employee;
use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class UniqueFounder implements ValidationRule
{
    protected ?int $ignoreId = null;

    public function __construct(?int $ignoreId = null)
    {
        $this->ignoreId = $ignoreId;
    }

    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        // When is_founder is true, ensure no other founder exists
        if ($value) {
            $query = Employee::where('is_founder', true);

            // Ignore current employee during updates
            if ($this->ignoreId) {
                $query->where('id', '!=', $this->ignoreId);
            }

            if ($query->exists()) {
                $fail('A founder already exists. There can only be one founder in the company.');
            }
        }
    }
}
