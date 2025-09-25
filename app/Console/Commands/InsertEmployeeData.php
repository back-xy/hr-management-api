<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Employee;

class InsertEmployeeData extends Command
{
    protected $signature = 'employees:insert {count=10 : Number of employees to create}';
    protected $description = 'Insert employee records with a progress bar';

    public function handle()
    {
        $count = (int) $this->argument('count');

        if ($count < 1) {
            $this->error('Count must be at least 1');
            return 1;
        }

        $this->info("Creating {$count} employee records...");

        // Create progress bar
        $bar = $this->output->createProgressBar($count);
        $bar->start();

        $created = 0;

        for ($i = 0; $i < $count; $i++) {
            try {
                Employee::factory()->create();
                $created++;
            } catch (\Exception $e) {
                // Skip failed creation, continue with next
            }
            $bar->advance();
        }

        $bar->finish();
        $this->newLine(2);

        $this->info("Successfully created {$created} out of {$count} employee records!");

        if ($created < $count) {
            $skipped = $count - $created;
            $this->warn("{$skipped} records were skipped due to errors");
        }

        return 0;
    }
}
