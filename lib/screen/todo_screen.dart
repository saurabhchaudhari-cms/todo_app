import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/providers/task_provider.dart';
import 'package:to_do_app/widget/add_bottomsheet.dart';

class Todo extends ConsumerStatefulWidget {
  Todo({super.key});

  @override
  ConsumerState<Todo> createState() => _TodoState();
}

class _TodoState extends ConsumerState<Todo> {
  TextEditingController taskController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    taskController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(taskProvider);
    final taskNotifier = ref.read(taskProvider.notifier);
    Widget searchTextField() {
      return TextField(
        controller: searchController,
        autofocus: true,
        onChanged: (value) => taskNotifier.searchList(value),
        decoration: InputDecoration(hintText: 'Search tasks...'),
      );
    }

    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => TaskBottomsheet(
              onAdd: (taskTitle) {
                taskNotifier.addTask(taskTitle);
              },
            ),
          );
        },
        child: Icon(Icons.add_circle),
      ),
      appBar: AppBar(
        title: isSearching ? searchTextField() : Text('Todo App'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                // if (!isSearching) {
                //   searchController.clear();
                //   taskNotifier.searchList('');
                // }
              });
            },
            icon: Icon(
              isSearching ? Icons.cancel_outlined : Icons.search_rounded,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final taskId = todos[index].id;
          return Dismissible(
            key: Key(taskId),
            onDismissed: (direction) => taskNotifier.removeTask(taskId),
            child: CheckboxListTile(
              title: Text(todos[index].title),
              value: todos[index].isDone,
              onChanged: (value) => taskNotifier.toggleTask(taskId),
            ),
          );
        },
        itemCount: todos.length,
      ),
    );
  }
}
