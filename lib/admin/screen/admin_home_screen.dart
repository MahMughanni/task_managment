import 'package:flutter/material.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Admin',
        action: [],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
