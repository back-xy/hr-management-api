<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;

class RemoveAllLogFiles extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'logs:clear {--dry-run : Preview without deleting} {--force : Skip confirmation}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Remove all log files from storage/logs directory';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $dryRun = $this->option('dry-run');
        $force = $this->option('force');

        $logPath = storage_path('logs');

        if (!File::exists($logPath)) {
            $this->info('Logs directory does not exist.');
            return 0;
        }

        $logFiles = File::files($logPath);

        if (empty($logFiles)) {
            $this->info('No log files found.');
            return 0;
        }

        $this->info('Found ' . count($logFiles) . ' log file(s):');

        foreach ($logFiles as $file) {
            $this->info('  - ' . $file->getFilename());
        }

        if ($dryRun) {
            $this->info('DRY RUN: Would delete ' . count($logFiles) . ' log files (no actual deletion).');
            return 0;
        }

        if ($force || $this->confirm('Do you want to delete all log files?')) {
            $deleted = 0;

            foreach ($logFiles as $file) {
                if (File::delete($file->getPathname())) {
                    $deleted++;
                }
            }

            $this->info("Deleted {$deleted} log file(s).");
        } else {
            $this->info('Operation cancelled.');
        }

        return 0;
    }
}
