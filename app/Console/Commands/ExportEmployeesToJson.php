<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use App\Models\Employee;

class ExportEmployeesToJson extends Command
{
    protected $signature = 'employees:export-json {--path= : Custom export path}';
    protected $description = 'Export all employee data to a JSON file';

    public function handle()
    {
        $customPath = $this->option('path');
        $timestamp = now()->format('Y-m-d_H-i-s');
        $filename = "employees_export_{$timestamp}.json";

        $exportPath = $customPath
            ? rtrim($customPath, '/\\') . DIRECTORY_SEPARATOR . $filename
            : storage_path('exports/' . $filename);

        $directory = dirname($exportPath);
        if (!File::exists($directory)) {
            File::makeDirectory($directory, 0755, true);
        }

        $this->info("Exporting employee data...");

        $employees = Employee::with(['position', 'manager'])->get();
        $json = $employees->toJson(JSON_PRETTY_PRINT);

        File::put($exportPath, $json);

        if (File::exists($exportPath)) {
            $fileSize = File::size($exportPath);
            $this->info("Employee data exported successfully!");
            $this->info("File: {$exportPath}");
            $this->info("Size: " . number_format($fileSize) . " bytes");
        } else {
            $this->error("Export failed. File was not created.");
            return 1;
        }

        return 0;
    }
}
