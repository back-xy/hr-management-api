<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\EmployeePosition>
 */
class EmployeePositionFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $minSalary = fake()->numberBetween(600, 2500) * 1000; // 600K - 2.5M IQD
        $maxSalary = $minSalary + fake()->numberBetween(200, 800) * 1000; // Additional 200K - 1.5M IQD

        return [
            'title' => fake()->jobTitle(),
            'description' => fake()->paragraph(1),
            'min_salary' => $minSalary,
            'max_salary' => $maxSalary,
            'is_active' => fake()->boolean(85),
        ];
    }
}
