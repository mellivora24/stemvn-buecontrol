import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarWidget({
    Key? key,
    this.actions,
    required this.title,
  }) : super(key: key);

  _openUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      throw 'Could not launch $url, error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'assets/in_app_logo.png',
            width: 100.0,
            height: 100.0,
          ),
          Text(
            title,
            style: const TextStyle(
              height: 1.5,
              fontSize: 20.0,
              letterSpacing: 2.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _openUrl('https://stemvn.vn'), // Mở link trợ giúp
                icon: const Icon(
                  Icons.help_outline,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => _openUrl('https://stemvn.vn'), // Mở link tài liệu
                icon: const Icon(
                  Icons.library_books_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
      elevation: 5.0,
      centerTitle: true,
      toolbarHeight: 70.0,
      backgroundColor: const Color(0xFFFF7337),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10.0);
}
