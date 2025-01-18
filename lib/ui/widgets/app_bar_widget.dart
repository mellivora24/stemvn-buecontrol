import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarWidget({
    Key? key,
    this.actions,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          letterSpacing: 2.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 5.0,
      actions: actions,
      centerTitle: true,
      toolbarHeight: 60.0,
      backgroundColor: const Color(0xFFFF7337),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
