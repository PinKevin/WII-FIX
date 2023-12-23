import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wii/main.dart';
import 'package:wii/screens/order_detail.dart';
import 'package:wii/utils/currencyFormatter.dart'; // Import file baru

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String selectedShift = '1';
  DateTime selectedDate = DateTime.parse('2023-12-22T08:16:26Z');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedShift = prefs.getString('shift') ?? '';
    selectedDate =
        DateTime.parse(prefs.getString('date') ?? '2023-12-22T08:16:26Z');
  }

  // @override
  // void initState() async {
  //   super.initState();
  //
  // }

  Future<List<Map<String, dynamic>>> _getTransactions() async {
    final response = await supabase
        .from('transaksi')
        .select(
            'idtransaksi, shift, status, kodemeja, namapelanggan, total, metodepembayaran')
        .eq('tanggal', selectedDate.toString())
        .eq('shift', selectedShift);

    List<Map<String, dynamic>> transactions = response.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    return transactions;
  }

  renderStatus(String status) {
    if (status == 'baru') {
      return 'Baru';
    } else if (status == 'diproses') {
      return 'Diproses';
    } else if (status == 'selesai') {
      return 'Selesai';
    } else if (status == 'ready') {
      return 'Siap Disajikan';
    } else {
      return status;
    }
  }

  statusColor(String status) {
    if (status == 'baru') {
      return Colors.blue;
    } else if (status == 'diproses') {
      return Colors.orange;
    } else if (status == 'selesai') {
      return Colors.green;
    } else if (status == 'ready') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
        elevation: 1,
        backgroundColor: Colors.purple.shade50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
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

            transactions?.sort((a, b) => a['tanggal'].compareTo(b['tanggal']));
            transactions?.sort((a, b) => a['waktu'].compareTo(b['waktu']));

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: transactions?.length,
              itemBuilder: (context, index) {
                var transaction = transactions![index];

                print(transaction);

                return GestureDetector(
                  onTap: () {
                    _showTransactionDetail(transaction);
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Colors.purple.shade100,
                        width: 0.3,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${transaction['idtransaksi']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${transaction['tanggal']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${transaction['waktu']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 0.5,
                          ),
                          Row(
                            children: [
                              Text(
                                '${transaction['namapelanggan']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(Meja ${transaction['kodemeja']})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                CurrencyFormat.convertToIdr(
                                    int.parse('${transaction['total']}'), 0),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              Badge(
                                label: Text(
                                    '${renderStatus(transaction['status'] ?? 'baru')}'),
                                largeSize: double.parse(24.toString()),
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                backgroundColor: statusColor(
                                    transaction['status'] ?? 'baru'),
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
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
    );
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailPage(
          transaction: transaction,
        ),
      ),
    );
  }
}
