import 'package:flutter/material.dart';
import 'package:task_mangment/shared_widgets/list_item_body.dart';

import '../../../shared_widgets/custom_appbar.dart';

class AssignedScreen extends StatelessWidget {
  const AssignedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbar(
        title: 'Assigned Tasks',
        action: [
          Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return ListViewItemBody(
            userName: '',
            taskCategory: '',
            startTime: '',
            title: '',
          );
        },
      ),
    );
  }
}
