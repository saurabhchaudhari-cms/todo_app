import 'package:flutter/material.dart';
import 'package:to_do_app/widget/task.dart';

void main() {
  runApp(MaterialApp(home: const Todo()));
}

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<Task> todos = [
    Task(title: 'Buy groceries'),
    Task(title: 'Walk the dog'),
    Task(title: 'Read a book'),
  ];

  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) => taskBottomsheet(context),
          );
        },
        child: Icon(Icons.add_circle),
      ),
      appBar: AppBar(title: Text('Todo App')),
      body: ListView.builder(
        itemBuilder: (context, index) => CheckboxListTile(
          title: Text(todos[index].title),
          value: todos[index].isDone,
          onChanged: (value) {
            setState(() {
              todos[index].isDone = value!;
            });
          },
        ),
        itemCount: todos.length,
      ),
    );
  }

  Widget taskBottomsheet(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: taskController,
          decoration: InputDecoration(hintText: 'Enter task'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              todos.add(Task(title: taskController.text));
              taskController.clear();
            });
            Navigator.pop(context);
          },
          child: Icon(Icons.check_circle),
        ),
      ],
    );
  }
}
