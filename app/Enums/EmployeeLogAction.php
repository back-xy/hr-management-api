<?php

namespace App\Enums;

enum EmployeeLogAction: string
{
    case CREATED = 'created';
    case UPDATED = 'updated';
    case DELETED = 'deleted';
}
