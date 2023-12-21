import 'package:flutter/material.dart';
import 'package:wii/components/bottom_app_bar.dart';
import 'package:wii/main.dart';
import 'package:wii/screens/order_detail.dart'; // Import file baru

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<List<Map<String, dynamic>>> _getTransactions() async {
    final response = await supabase.from('transaksi').select(
        'idtransaksi, shift, status, kodemeja, namapelanggan, total, metodepembayaran');

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
            var transactions = snapshot.data;

            return ListView.builder(
              itemCount: transactions?.length,
              itemBuilder: (context, index) {
                var transaction = transactions![index];

                return GestureDetector(
                  onTap: () {
                    _showTransactionDetail(transaction);
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Shift: ${transaction['shift']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${transaction['kodemeja']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${transaction['namapelanggan']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${transaction['total']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${transaction['status']}',
                                style: TextStyle(
                                  color: transaction['status'] == 'baru' ||
                                          transaction['status'] == 'diproses'
                                      ? const Color.fromARGB(255, 255, 0, 0)
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomBar.showBottomAppBar(context),
    );
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailPage(transaction: transaction),
      ),
    );
  }
}
