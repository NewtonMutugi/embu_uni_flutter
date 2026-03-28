import 'package:flutter/material.dart';
import 'package:task_app/models/Task.dart';
import 'package:task_app/screens/TaskScreen.dart';

void main() {
  runApp(const TaskApp());
}
class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple task app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

