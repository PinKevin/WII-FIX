import 'package:flutter/material.dart';
import 'package:wii/components/bottom_app_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WII'),
        ),
        body: const Center(
          child: Text('Selamat datang di WII'),
        ),
        bottomNavigationBar: BottomBar.showBottomAppBar(context));
  }
}
