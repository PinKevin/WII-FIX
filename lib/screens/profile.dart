import 'package:flutter/material.dart';
import 'package:wii/components/bottomNavigationBar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: const Center(
        child: Text('Profil'),
      ),
      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 3,
      ),
    );
  }
}
