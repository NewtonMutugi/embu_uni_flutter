import 'package:flutter/material.dart';
import 'package:task_app/models/Task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];

  final TextEditingController _taskController = TextEditingController();

  void _addTask(String title) {
    if (title.trim().isEmpty) return; // Don't add empty tasks

    setState(() {
      _tasks.add(
        Task(
          id: DateTime.now().toString(), // Generates a simple unique ID
          title: title,
        ),
      );
    });
    _taskController.clear(); // Clear the text field
    Navigator.pop(context); // Close the popup dialog
  }

  void _editTask(String id, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    setState(() {
      // Find the specific task and update its title
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        _tasks[taskIndex].title = newTitle;
      }
    });
    _taskController.clear();
    Navigator.pop(context);
  }

  // [U]PDATE: Toggle the checkbox (Completed / Not Completed)
  void _toggleTaskCompletion(String id) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      }
    });
  }

  // [D]ELETE: Remove a task from the list
  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  // --------------------------------------------------------
  // UI HELPERS
  // --------------------------------------------------------

  // Opens a popup dialog to either Add or Edit a task
  void _showTaskDialog({Task? taskToEdit}) {
    final isEditing = taskToEdit != null;

    // Pre-fill the text field if we are editing
    if (isEditing) {
      _taskController.text = taskToEdit.title;
    } else {
      _taskController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Task' : 'Add New Task'),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g., Buy groceries'),
            onSubmitted: (value) {
              isEditing ? _editTask(taskToEdit.id, value) : _addTask(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                isEditing
                    ? _editTask(taskToEdit.id, _taskController.text)
                    : _addTask(_taskController.text);
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks (CRUD)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // [R]EAD: Displaying our data
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet. Click the + button to add one!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    // Update trigger: Checkbox
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) => _toggleTaskCompletion(task.id),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    // Action buttons
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Update trigger: Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showTaskDialog(taskToEdit: task),
                        ),
                        // Delete trigger: Trash Button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(task.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      // Create trigger: Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
