import 'package:flutter/material.dart';
import 'package:wii/components/bottom_app_bar.dart';
import 'package:wii/main.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<List<String>> _getTransactions() async {
    final response = await supabase.from('transaksi').select('kodemeja');

    List<String> kodeMejaList =
        response.map((item) => item['kodemeja'].toString()).toList();

    return kodeMejaList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Transaksi'),
        ),
        body: FutureBuilder<List<String>>(
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
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(transactions![index]),
                        ),
                      );
                    });
              }
            }),
        bottomNavigationBar: BottomBar.showBottomAppBar(context));
  }
}
