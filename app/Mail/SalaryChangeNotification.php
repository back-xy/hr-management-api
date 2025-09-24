<?php

namespace App\Mail;

use App\Models\Employee;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class SalaryChangeNotification extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public function __construct(
        public Employee $employee,
        public int $oldSalary,
        public int $newSalary,
        public bool $isForEmployee = false
    ) {}

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        $subject = $this->isForEmployee
            ? 'Salary Update Notification'
            : "Employee Salary Change - {$this->employee->name}";

        return new Envelope(
            subject: $subject,
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            text: 'emails.salary-change',
            with: [
                'employee' => $this->employee,
                'oldSalary' => $this->oldSalary,
                'newSalary' => $this->newSalary,
                'difference' => $this->newSalary - $this->oldSalary,
                'isIncrease' => $this->newSalary > $this->oldSalary,
                'percentChange' => round((($this->newSalary - $this->oldSalary) / $this->oldSalary) * 100, 1),
                'isForEmployee' => $this->isForEmployee,
            ],
        );
    }

    /**
     * Get the attachments for the message.
     */
    public function attachments(): array
    {
        return [];
    }
}
