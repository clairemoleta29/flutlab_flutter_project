Reflection
After completing the application, answer the following questions:

Your answers should refer to your implementation and explain the reasoning behind your design decisions.

1. Why does the application use SQLite instead of relying only on a Dart list?
2. What is the purpose of the primary key in the tasks table?
3. How does the repository simplify the UI's interaction with the database?
4. What would happen if a task were removed from the displayed list but not deleted from SQLite?
5. If the database schema later needed a new column for task priority, what parts of the application might
need to change?

ANSWERS:
1. To provide persistent storage so tasks are saved across app restarts, unlike an in-memory Dart list which clears when the app closes.   
2. To uniquely identify each task record, allowing precise updates and deletions without affecting other rows.
3. It encapsulates SQL queries and database logic, shielding the UI from database complexity and keeping code modular.   
4. It creates a synchronization mismatch; the task would reappear on the screen the next time the app restarts or refreshes its data.
5. You must update the data model (task.dart), the SQL table schema/migration (task_repository.dart), and the UI inputs/views (main.dart) to handle the new field.
