<?php

namespace App\Console\Commands;

use App\Models\EmployeeLog;
use Illuminate\Console\Command;
use Carbon\Carbon;

class DeleteOldEmployeeLogs extends Command
{
    protected $signature = 'logs:delete-old {months=1 : Number of months old} {--dry-run : Preview without deleting} {--force : Skip confirmation}';
    protected $description = 'Delete employee logs older than specified months';

    public function handle()
    {
        $months = (int) $this->argument('months');
        $dryRun = $this->option('dry-run');
        $force = $this->option('force');

        $cutoffDate = Carbon::now()->subMonths($months);

        $count = EmployeeLog::where('created_at', '<', $cutoffDate)->count();

        if ($count === 0) {
            $this->info("No employee logs older than {$months} month(s) found.");
            return 0;
        }

        $this->info("Found {$count} employee logs older than {$months} month(s).");

        if ($dryRun) {
            $this->info("DRY RUN: Would delete {$count} employee logs (no actual deletion).");
            return 0;
        }

        if ($force || $this->confirm('Do you want to delete them?')) {
            $deleted = EmployeeLog::where('created_at', '<', $cutoffDate)->delete();
            $this->info("Deleted {$deleted} employee logs.");
        } else {
            $this->info('Operation cancelled.');
        }

        return 0;
    }
}
