<?php

namespace App\Enums;

enum EmployeeStatus: string
{
    case ACTIVE = 'active';
    case INACTIVE = 'inactive';
    case TERMINATED = 'terminated';

    public static function values(): array
    {
        return array_map(fn($case) => $case->value, self::cases());
    }
}
