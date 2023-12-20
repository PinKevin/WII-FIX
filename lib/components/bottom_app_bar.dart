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
                  print('Home');
                },
                icon: const Icon(Icons.home)),
            // ignore: avoid_print
            IconButton(
                onPressed: () {
                  print('List');
                },
                icon: const Icon(Icons.list)),
            IconButton(
                onPressed: () {
                  print('Profile');
                },
                icon: const Icon(Icons.person))
          ],
        ));
  }
}
