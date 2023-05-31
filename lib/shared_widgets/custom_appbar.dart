import 'package:flutter/material.dart';
import 'package:task_management/core/routes/app_router.dart';

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppbar(
      {Key? key,
      required this.title,
      required this.action,
      this.bottom,
      this.height})
      : super(key: key);
  final String title;
  final List<Widget> action;

  final PreferredSizeWidget? bottom;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      titleSpacing: 24,
      leading: IconButton(
          onPressed: () {
            AppRouter.mayBack();
          },
          icon: Icon(Icons.arrow_back_ios)),
      centerTitle: false,
      iconTheme: IconTheme.of(context).copyWith(color: Colors.black),
      automaticallyImplyLeading: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: action,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 70);
}
