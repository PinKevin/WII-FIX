import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wii/main.dart';
import 'package:wii/screens/orders.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool shift1Selected = false;
  bool shift2Selected = false;

  DateTime? selectedDate;

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(selectedDate != null
                        ? 'Tanggal: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'
                        : 'Pilih tanggal')),
                const SizedBox(height: 20),
                ToggleButtons(
                    isSelected: [shift1Selected, shift2Selected],
                    onPressed: (index) {
                      setState(() {
                        if (index == 0) {
                          shift1Selected = true;
                          shift2Selected = false;
                        } else {
                          shift1Selected = false;
                          shift2Selected = true;
                        }
                      });
                    },
                    children: const [Text('Shift 1'), Text('Shift 2')]),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (shift1Selected || shift2Selected)
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrdersPage(
                                        selectedDate: selectedDate,
                                        shift1Selected: shift1Selected,
                                        shift2Selected: shift2Selected,
                                      )));
                        }
                      : null,
                  child: const Text('Pilih Shift'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
