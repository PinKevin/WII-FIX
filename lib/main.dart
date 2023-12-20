import 'package:flutter/material.dart';
import 'package:wii/screens/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rvbhznsrqtjgbsyfuyyr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2Ymh6bnNycXRqZ2JzeWZ1eXlyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMwNjcwNDQsImV4cCI6MjAxODY0MzA0NH0.o-xVxQEbRcv4_YmzaflhLKHohI7R3s5EXKes3J059JA',
  );
  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WII',
      home: LoginPage(),
    );
  }
}
