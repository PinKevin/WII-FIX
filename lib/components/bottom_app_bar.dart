import 'package:flutter/material.dart';

class BottomBar {
  static BottomAppBar showBottomAppBar(BuildContext context) {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                icon: const Icon(Icons.home)),
            // ignore: avoid_print
            IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/profile');
                },
                icon: const Icon(Icons.person))
          ],
        ));
  }
}
