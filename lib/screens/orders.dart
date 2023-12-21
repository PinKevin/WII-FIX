import 'package:flutter/material.dart';
import 'package:wii/components/bottom_app_bar.dart';
import 'package:wii/main.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<List<Map<String, dynamic>>> _getTransactions() async {
    final response = await supabase.from('transaksi').select(
        'shift, status, kodemeja, namapelanggan, total, metodepembayaran');

    List<Map<String, dynamic>> transactions = response.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Transaksi'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _getTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var transactions = snapshot.data;

                return ListView.builder(
                    itemCount: transactions?.length,
                    itemBuilder: (context, index) {
                      var transaction = transactions![index];

                      return Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var entry in transaction.entries)
                                ListTile(
                                  title: Text('${entry.key}: ${entry.value}'),
                                )
                            ],
                          ));
                    });
              }
            }),
        bottomNavigationBar: BottomBar.showBottomAppBar(context));
  }
}
