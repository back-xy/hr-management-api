<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Employee extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'name',
        'email',
        'salary',
        'position_id',
        'manager_id',
        'is_founder',
        'hire_date',
        'phone',
        'address',
        'status',
        'last_salary_change',
    ];

    protected $casts = [
        'is_founder' => 'boolean',
        'hire_date' => 'date',
        'last_salary_change' => 'datetime',
    ];

    /**
     * Get the employee position that the employee belongs to.
     */
    public function position(): BelongsTo
    {
        return $this->belongsTo(EmployeePosition::class, 'position_id');
    }

    /**
     * Get the manager of the employee.
     */
    public function manager(): BelongsTo
    {
        return $this->belongsTo(Employee::class, 'manager_id');
    }

    /**
     * Get the subordinates of the employee.
     */
    public function subordinates(): HasMany
    {
        return $this->hasMany(Employee::class, 'manager_id');
    }

    /**
     * Get all employee logs for this employee.
     */
    public function logs(): HasMany
    {
        return $this->hasMany(EmployeeLog::class);
    }

    /**
     * Get the hierarchy of managers up to the founder.
     */
    public function getManagerHierarchy(): array
    {
        $hierarchy = [];
        $current = $this->manager;

        while ($current) {
            $hierarchy[] = $current;
            $current = $current->manager;
        }

        return $hierarchy;
    }

    /**
     * Get the hierarchy of managers with names only.
     */
    public function getManagerHierarchyNames(): array
    {
        return collect($this->getManagerHierarchy())->pluck('name')->toArray();
    }

    /**
     * Get the hierarchy of managers with names and salaries.
     */
    public function getManagerHierarchyWithSalaries(): array
    {
        return collect($this->getManagerHierarchy())
            ->mapWithKeys(function ($manager) {
                return [$manager->name => $manager->salary];
            })
            ->toArray();
    }

    /**
     * Scope to get employees who haven't had salary changes in X months.
     */
    public function scopeWithoutSalaryChangeInMonths($query, int $months)
    {
        $date = now()->subMonths($months);

        return $query->where(function ($q) use ($date) {
            $q->where('last_salary_change', '<', $date)
                ->orWhereNull('last_salary_change');
        });
    }

    /**
     * Scope to search by name or salary.
     */
    public function scopeSearch($query, $name = null, $salary = null)
    {
        if ($name) {
            $query->where('name', 'like', "%{$name}%");
        }

        if ($salary) {
            $query->where('salary', $salary);
        }

        return $query;
    }

    /**
     * Get the founder of the company.
     */
    public static function founder()
    {
        return static::where('is_founder', true)->first();
    }
}
