<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
use App\Enums\EmployeeStatus;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('employees', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->integer('salary')->nullable();
            $table->foreignId('position_id')->nullable()->constrained('employee_positions')->onDelete('set null');
            $table->foreignId('manager_id')->nullable()->constrained('employees')->onDelete('set null');
            $table->boolean('is_founder')->default(false);
            $table->date('hire_date');
            $table->string('phone')->nullable();
            $table->text('address')->nullable();
            $table->enum('status', EmployeeStatus::values())->default(EmployeeStatus::ACTIVE->value);
            $table->timestamp('last_salary_change')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index('manager_id');
            $table->index('last_salary_change');
        });


        // unique constraint for the founder
        DB::statement('CREATE UNIQUE INDEX unique_founder ON employees (is_founder) WHERE is_founder = true');
        // non-founders must have a manager constraint
        DB::statement('
            ALTER TABLE employees 
            ADD CONSTRAINT check_manager_required 
            CHECK (is_founder = true OR manager_id IS NOT NULL)
        ');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('employees');
    }
};
