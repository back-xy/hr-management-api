# HR Management API

This project is a Laravel-based API for comprehensive Human Resources Management System with hierarchical employee structure, extensive logging, and data management.

## Features

- **Employee Management**:
  - Complete CRUD operations with hierarchical relationships
  - Manager-employee hierarchy tracking
  - Employee search by name or salary
  - CSV/JSON export functionality (CSV import not implemented)
  - Salary change notifications and tracking
- **Position Management**:
  - Job position CRUD operations
  - Salary range definitions
  - Active/inactive status management
- **Logging & Monitoring**:
  - Database logging for all employee operations
  - File logging with custom employee.log channel
  - Action tracking with user details
- **Data Management Commands**:
  - Delete old logs with configurable timeframe
  - Remove all log files
  - Export database to SQL format
  - Export employees to JSON
  - Employee data seed with progress tracking
- **Authentication**:
  - Token-based authentication using Laravel Sanctum
  - Rate limiting (10 requests per minute)

## API Endpoints

### Authentication
- `POST /auth/register` - Register new user account
- `POST /auth/login` - Get authentication token
- `POST /auth/logout` - Invalidate current token

### Employee Operations
- `GET /employees` - List all employees (paginated, searchable)
- `POST /employees` - Create new employee
- `GET /employees/{id}` - Get employee details
- `PUT /employees/{id}` - Update employee information
- `DELETE /employees/{id}` - Delete employee
- `GET /employees/{id}/hierarchy` - Get manager hierarchy (names only)
- `GET /employees/{id}/hierarchy-with-salaries` - Get hierarchy with salary details
- `GET /employees/no-salary-change/{months}` - Get employees without salary changes
- `GET /employees/export/csv` - Export employees to CSV

### Position Operations
- `GET /positions` - List all positions
- `POST /positions` - Create new position
- `GET /positions/{id}` - Get position details
- `PUT /positions/{id}` - Update position
- `DELETE /positions/{id}` - Delete position


## Artisan Commands

### Log Management
```bash
# Delete old employee logs (older than specified months)
php artisan logs:delete-old {months=1} {--dry-run} {--force}

# Remove all log files from storage/logs directory
php artisan logs:clear {--dry-run} {--force}
```

### Data Export/Import
```bash
# Export database to SQL file
php artisan db:export-sql {--path=}

# Export employees to JSON file with relationships
php artisan employees:export-json {--path=}

# Insert employee data using factories (with progress bar)
php artisan employees:insert {count=10}
```

## Setup Guide

### Prerequisites
- PHP 8.2+
- Composer
- PostgreSQL
- Laravel 12+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/back-xy/hr-management-api.git
   cd hr-management-api
   ```

2. Install dependencies:
   ```bash
   composer install
   ```

3. Configure environment:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. Update `.env` with your database credentials:
   ```ini
   DB_CONNECTION=pgsql
   DB_HOST=127.0.0.1
   DB_PORT=5432
   DB_DATABASE=hr_management
   DB_USERNAME=postgres
   DB_PASSWORD=
   ```

5. Run migrations:
   ```bash
   php artisan migrate --seed
   ```

### Running the Application

Start the development server:
```bash
php artisan serve
```

The API will be available at `http://localhost:8000`

## Database

A complete database export with sample data is included at `database/dumps/hr_management_database.sql`.

## Documentation

API documentation is available in the source code under `HR Management API`.

## Testing

Not Implemented