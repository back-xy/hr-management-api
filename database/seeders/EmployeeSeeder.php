<?php

namespace Database\Seeders;

use App\Models\Employee;
use App\Models\EmployeePosition;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class EmployeeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        if (EmployeePosition::count() === 0) {
            $this->call(EmployeePositionSeeder::class);
        }

        $positionIds = EmployeePosition::pluck('id')->toArray();

        // Create founder
        $founder = Employee::factory()->create([
            'salary' => fake()->numberBetween(3000, 5000) * 1000, // 3M-5M IQD
            'position_id' => fake()->randomElement($positionIds),
            'manager_id' => null,
            'is_founder' => true,
            'hire_date' => fake()->dateTimeBetween('-10 years', '-5 years'),
            'status' => 'active',
        ]);

        // Create managers reporting to founder
        $managers = Employee::factory()->count(25)->create([
            'salary' => fn() => fake()->numberBetween(1500, 2500) * 1000, // 1.5M-2.5M IQD
            'position_id' => fn() => fake()->randomElement($positionIds),
            'manager_id' => $founder->id,
            'hire_date' => fn() => fake()->dateTimeBetween('-5 years', '-1 year'),
            'status' => 'active',
        ]);

        $allManagers = $managers->push($founder);

        // Create regular employees
        Employee::factory()->count(500)->create([
            'position_id' => fn() => fake()->randomElement($positionIds),
            'manager_id' => fn() => $allManagers->random()->id,
        ]);
    }
}
