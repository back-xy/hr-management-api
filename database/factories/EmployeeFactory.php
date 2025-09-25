<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Employee>
 */
class EmployeeFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => fake()->name(),
            'email' => fake()->unique()->safeEmail(),
            'salary' => fake()->numberBetween(600, 2500) * 1000, // 600K-2.5M IQD
            'position_id' => \App\Models\EmployeePosition::inRandomOrder()->first()?->id ?? 1,
            'manager_id' => \App\Models\Employee::inRandomOrder()->first()?->id ?? 1,
            'is_founder' => false,
            'hire_date' => fake()->dateTimeBetween('-3 years', '-1 month'),
            'phone' => fake()->phoneNumber(),
            'address' => fake()->address(),
            'status' => fake()->boolean(75) ? 'active' : 'inactive',
            'last_salary_change' => fake()->dateTimeBetween('-12 months', '-1 week'),
        ];
    }
}
