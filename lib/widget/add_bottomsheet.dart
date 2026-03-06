import 'package:flutter/material.dart';
import 'package:to_do_app/models/task.dart';

class TaskBottomsheet extends StatelessWidget {
  TaskBottomsheet({super.key, required this.onAdd});
  final TextEditingController controller = TextEditingController();
  final void Function(String) onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter task'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isEmpty) return;
              onAdd(controller.text.trim());
              controller.clear();
              Navigator.pop(context);
            },
            child: Icon(Icons.check_circle),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
