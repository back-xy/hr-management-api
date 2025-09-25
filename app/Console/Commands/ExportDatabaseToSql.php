<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;

class ExportDatabaseToSql extends Command
{
    protected $signature = 'db:export-sql {--path= : Custom export path}';
    protected $description = 'Export database to SQL file using pg_dump';

    public function handle()
    {
        $customPath = $this->option('path');
        $config = config('database.connections.pgsql');

        $timestamp = now()->format('Y-m-d_H-i-s');
        $filename = "database_export_{$timestamp}.sql";
        $exportPath = $customPath
            ? rtrim($customPath, '/\\') . DIRECTORY_SEPARATOR . $filename
            : storage_path('exports/' . $filename);

        $directory = dirname($exportPath);
        if (!File::exists($directory)) {
            File::makeDirectory($directory, 0755, true);
        }

        $this->info("Exporting database...");

        // Set the password via environment variable for compatibility
        putenv("PGPASSWORD={$config['password']}");
        $command = sprintf(
            'pg_dump -h %s -p %s -U %s --clean --if-exists --file="%s" %s',
            $config['host'],
            $config['port'],
            $config['username'],
            $exportPath,
            $config['database']
        );

        exec($command, $output, $returnCode);

        // Unset environment variable
        putenv("PGPASSWORD");

        if ($returnCode === 0 && File::exists($exportPath)) {
            $fileSize = File::size($exportPath);
            $this->info("Database exported successfully!");
            $this->info("File: {$exportPath}");
            $this->info("Size: " . number_format($fileSize) . " bytes");
        } else {
            $this->error("Export failed with return code: {$returnCode}");
            foreach ($output as $line) {
                $this->line($line);
            }
            return 1;
        }

        return 0;
    }
}
