import 'package:flutter/material.dart';
import 'package:wii/components/snackbar.dart';
import 'package:wii/main.dart';
import 'package:wii/screens/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> authenticateUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final response = await supabase
        .from('pengguna')
        .select('username, password')
        .eq('username', username)
        .single();

    final user = response;
    final storedPassword = user['password'].toString();

    if (storedPassword == password) {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const DashboardPage()));
    } else {
      // ignore: use_build_context_synchronously
      CustomSnackBar.showSnackBar(context, 'Login gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  authenticateUser();
                },
                child: const Text('Login'),
              ),
            ],
          )),
    );
  }
}
