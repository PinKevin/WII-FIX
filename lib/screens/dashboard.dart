import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wii/main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool shift1Selected = false;
  bool shift2Selected = false;

  Future<String?> _getNamapengguna() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    final response = await supabase
        .from('pengguna')
        .select('namapengguna')
        .eq('username', username!)
        .single();

    return response['namapengguna'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.purple.shade50,
            height: 200,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Warmindo Inspirasi Indonesia',
                    style: TextStyle(color: Colors.black38)),
                FutureBuilder<String?>(
                  future: _getNamapengguna(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Selamat Datang, ${snapshot.data}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  },
                )
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -70.0, 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.purple.shade50),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      shift1Selected = true;
                      shift2Selected = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: shift1Selected
                        ? MaterialStateProperty.all(Colors.blue)
                        : MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text('Shift 1'),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      shift1Selected = false;
                      shift2Selected = true;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: shift2Selected
                        ? MaterialStateProperty.all(Colors.blue)
                        : MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text('Shift 2'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: (shift1Selected || shift2Selected)
                        ? () {
                            print('Halo');
                          }
                        : null,
                    child: const Text('Pilih Shift'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
