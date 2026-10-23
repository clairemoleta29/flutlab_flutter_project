import 'package:flutter/material.dart';
import 'task.dart';
import 'task_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff1c97ad), // Professional Teal/Slate Accent
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  final TextEditingController _controller = TextEditingController();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    final tasks = await _taskRepository.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask() async {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task title cannot be empty or whitespace.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      final newTask = Task(title: title);
      await _taskRepository.insertTask(newTask);
      _controller.clear();
      await _refreshTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: $e')),
      );
    }
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        isCompleted: task.isCompleted == 1 ? 0 : 1,
      );
      await _taskRepository.updateTask(updatedTask);
      await _refreshTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    }
  }

  Future<void> _deleteTask(int id) async {
    try {
      await _taskRepository.deleteTask(id);
      await _refreshTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t.isCompleted == 1).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xff1c97ad),
        centerTitle: false,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Completed: $completedCount/${_tasks.length}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Section Card
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Enter a new task...',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xff1c97ad), width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _addTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1c97ad),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text(
                          'Add Task',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section Header
              const Text(
                'ACTIVE TASKS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 12),

              // Task List View
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: _tasks.isEmpty
                      ? const Center(
                          child: Text(
                            'No records found.\nCreate your first task above.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: _tasks.length,
                          separatorBuilder: (context, index) => const Divider(
                              height: 1, color: Color(0xFFF1F5F9)),
                          itemBuilder: (context, index) {
                            final task = _tasks[index];
                            final isDone = task.isCompleted == 1;

                            return ListTile(
                              leading: Checkbox(
                                value: isDone,
                                activeColor: const Color(0xff1c97ad),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (bool? value) {
                                  _toggleTaskCompletion(task);
                                },
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isDone
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF1E293B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: Color(0xFFEF4444),
                                ),
                                tooltip: 'Delete Task',
                                onPressed: () => _deleteTask(task.id!),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
