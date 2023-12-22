import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wii/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');

    Navigator.pushReplacementNamed(context, '/');
  }

  Future<String>? _getPengguna() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');

    final response = await supabase
        .from('pengguna')
        .select()
        .eq('username', username!)
        .single();

    return response['namapengguna'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<String>(
              future: _getPengguna(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return Text("Selamat Datang, ${snapshot.data}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold));
                }
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity, 50)),
                    onPressed: () {
                      _logout();
                      print('Keluar');
                    },
                    child: const Text('Keluar'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
