# HR Management API

A Laravel-based API for comprehensive Human Resources Management System with hierarchical employee structure, extensive logging, and data management commands.

## Features

- **Employee Management**:
  - Complete CRUD operations with hierarchical relationships
  - Manager-employee hierarchy tracking
  - Employee search by name or salary
  - CSV/JSON import and export functionality
  - Salary change notifications and tracking
- **Position Management**:
  - Job position CRUD operations
  - Salary range definitions
  - Active/inactive status management
- **Logging & Monitoring**:
  - Database logging for all employee operations
  - File logging with custom employee.log channel
  - Action tracking with user details and IP addresses
- **Data Management Commands**:
  - Delete old logs with configurable timeframe
  - Remove all log files with dry-run option
  - Export database to SQL format
  - Export employees to JSON
  - Bulk employee data seed with progress tracking
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

### Position Operations
- `GET /positions` - List all positions
- `POST /positions` - Create new position
- `GET /positions/{id}` - Get position details
- `PUT /positions/{id}` - Update position
- `DELETE /positions/{id}` - Delete position

### Data Operations
- `GET /employees/export/csv` - Export employees to CSV
- `POST /employees/import/csv` - Import employees from CSV file
- `GET /employees/no-salary-change/{months}` - Get employees without salary changes

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

## Testing

Not Implemented

## Documentation

API documentation is available in the source code under `HR Management API`.