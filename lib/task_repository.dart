import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'task.dart';

class TaskRepository {
  static Database? _database;

  // Get database instance (Requirement 5: Repository pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  // Initialize database and tasks table (Requirement 1)
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  // Insert a task (Requirement 2)
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  // Retrieve all tasks (Requirement 3)
  Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'id DESC');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Update a task's completion status (Requirement 4)
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task (Requirement 4)
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
