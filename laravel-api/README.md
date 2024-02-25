# Expense Tracker Backend API

Welcome to the Expense Tracker Backend API! This Laravel project serves as the backend for managing expenses, providing authentication using Laravel Passport.

## Table of Contents
- [Authentication](#authentication)
- [Expense Endpoints](#expense-endpoints)
  - [Create Expense](#create-expense)
  - [List Expenses](#list-expenses)
  - [Update Expense](#update-expense)
  - [Delete Expense](#delete-expense)
- [Getting Started](#getting-started)

## Authentication
To interact with the Expense Tracker API, you'll need to authenticate. The authentication is handled using Laravel Passport, and the following endpoints are available:

- **Register:** `POST /api/register`
  - Create a new user account.

- **Login:** `POST /api/login`
  - Obtain an access token for subsequent requests.

- **Logout:** `POST /api/logout`
  - Logout and invalidate the current access token. (Requires authentication)

## Expense Endpoints
Once authenticated, you can manage expenses through the following endpoints:

### Create Expense
- **Endpoint:** `POST /api/expenses`
- **Description:** Create a new expense.
- **Request Body:**
  ```json
  {
    "amount": 50.0,
    "description": "Dinner",
    "date": "2023-12-12",
    "category": "Food"
  }

### List Expenses
- **Endpoint:** `GET /api/expenses`
- **Description:** Get a list of all expenses.
- **Authentication: Required**


### Update Expense
- **Endpoint:** `PATCH /api/expenses/{expense_id}`
- **Description:** Update an existing expense.
- **Request Body:**
  ```json
  {
      "amount": 60.0,
      "description": "Dinner with friends",
      "date": "2023-12-12",
      "category": "Food"
  }
  
### Delete Expense
- **Endpoint:** `DELETE /api/expenses/{expense_id}`
- **Description:** Delete an existing expense.
- **Authentication: Required**


## Getting Started

1. **Clone the repository:**

   ```bash
   git clone https://github.com/govind72/expense-tracker.git
   
2. **Install dependencies:**
   ```bash
   composer install
3. **Copy the .env.example file to .env and configure your database:**
   ```bash
   cp .env.example .env

4. **Generate the application key:**
   ```bash
   php artisan key:generate

5. **Run migrations:**
   ```bash
   php artisan migrate
6. **Install Passport:**
    ```bash
    php artisan passport:install
7. **Start the development server:**
   ```bash
   php artisan serve


Your Expense Tracker API is now running at http://localhost:8000.
