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
                  Navigator.pushNamed(context, '/dashboard');
                },
                icon: const Icon(Icons.home)),
            // ignore: avoid_print
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/orders');
                },
                icon: const Icon(Icons.list)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                icon: const Icon(Icons.person))
          ],
        ));
  }
}
