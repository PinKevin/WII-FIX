import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wii/components/bottom_app_bar.dart';
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
        appBar: AppBar(
          title: FutureBuilder<String?>(
              future: _getNamapengguna(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else {
                    return Text(snapshot.data ?? 'Tamu');
                  }
                }
              }),
        ),
        body: Center(
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
                child: const Text('Pilih Shift'))
          ],
        )),
        bottomNavigationBar: BottomBar.showBottomAppBar(context));
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
