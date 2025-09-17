# Task Management App – Flutter

A Flutter-based Task Management App built using **Clean Architecture**, **Bloc** for state management, and **Hive** for local persistence.  
The app allows users to create, edit, delete, and sort tasks with a **clean and responsive Material Design UI**.

---

## Features

- **Task CRUD:** Create, edit, delete, and mark tasks as completed.
- **Sorting & Filtering:** Sort tasks by due date or status.
- **Local Persistence:** Uses **Hive** to store tasks locally across app sessions.
- **State Management:** Implements **Bloc** for predictable and maintainable state management.
- **Clean Architecture:** Structured into **Domain, Data, and Presentation layers** for scalability and maintainability.
- **Responsive Design:** Follows Material Design principles to look good on different screen sizes.

---

## Architecture

- **Domain Layer:** Contains business logic and entities, independent of frameworks/UI.
- **Data Layer:** Manages data sources including **Hive** for local storage and mock API.
- **Presentation Layer:** Handles UI and user interactions using **Bloc**.

---

## Screens

1. **Task List Screen:** View all tasks with title, description, status, and due date.
2. **Add Task Screen:** Add a new task with validation for required fields.
3. **Edit Task Screen:** Edit existing task details with pre-filled data.

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0
- Android Studio / VS Code with Flutter plugin

### Installation

```bash
# Clone the repository
git clone https://github.com/paul-thommithazhe/task_management.git

# Navigate to the project directory
cd task_management_app

# Install dependencies
flutter pub get

# Run the app
flutter run
