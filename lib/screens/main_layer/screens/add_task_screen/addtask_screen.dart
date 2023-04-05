import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white54,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Create Task',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
