import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppbar({Key? key, required this.title, required this.action})
      : super(key: key);
  final String title;
  final List<Widget> action;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      titleSpacing: 16,
      centerTitle: false,
      automaticallyImplyLeading: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: action,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
