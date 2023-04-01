import 'package:flutter/material.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/custom_tabBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: const TabBarViewTabs(),
          ),
          body: const TabBarView(
            children: [
              Text('1'),
              Text('2'),
              Text('3'),
            ],
          )),
    );
  }
}
