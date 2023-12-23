import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wii/main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int? selectedShift;
  DateTime? selectedDate;

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('shift'));
    setState(() {
      selectedShift = prefs.getInt('shift')!;
      selectedDate = DateTime.parse(prefs.getString('date')!);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(selectedDate != null
                          ? '${selectedDate?.day}-${selectedDate?.month}-${selectedDate?.year}'
                          : 'Pilih tanggal'),
                      Text('Shift $selectedShift'),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: Colors.purple.shade100, width: 0.5),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      'Pesanan baru',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('1'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: Colors.purple.shade100, width: 0.5),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      'Pesanan baru',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('1'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )),
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
