import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabBtn,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.home_outlined,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.file_copy_outlined,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.file_copy_outlined,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.file_copy_outlined,
              )),
        ],
      ),
    );
  }

  void onTabBtn(index) {
    setState(() {
      currentIndex = index;
    });
  }
}
