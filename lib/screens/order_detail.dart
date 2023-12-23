import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wii/main.dart';
import 'package:wii/screens/orders.dart';

class TransactionDetailPage extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailPage({
    super.key,
    required this.transaction,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late String status;
  late List<Map<String, dynamic>> detailTransactions;

  @override
  void initState() {
    super.initState();
    // Set the initial status from the transaction data
    status = widget.transaction['status'];
    detailTransactions = [];
    // Fetch transaction details when the page is initialized
    _getDetailTransactions(widget.transaction['idtransaksi']);
  }

  _getDetailTransactions(String idtransaksi) async {
    final response = await supabase
        .from('detail_transaksi')
        .select('namamenu, jumlah')
        .eq('idtransaksi', idtransaksi)
        .eq('status', 1);

    setState(() {
      detailTransactions = response.map((item) {
        return {
          'namamenu': item['namamenu'] as String,
          'jumlah': item['jumlah'].toString()
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Shift', widget.transaction['shift']),
            _buildDetailRow('Kode Meja', widget.transaction['kodemeja']),
            _buildDetailRow(
                'Nama Pelanggan', widget.transaction['namapelanggan']),
            _buildDetailRow('Total', widget.transaction['total']),
            _buildDetailRow(
                'Metode Pembayaran', widget.transaction['metodepembayaran']),
            _buildDetailRow('Status', status),
            const SizedBox(height: 16),
            const Text(
              'Detail Transaksi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            if (detailTransactions.isNotEmpty)
              Column(
                children: detailTransactions
                    .map((detail) => ListTile(
                          title: Text(detail['namamenu']),
                          subtitle: Text(detail['jumlah']),
                        ))
                    .toList(),
              )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Call a function to update the status
          _updateStatus();
          // Navigate to order.dart
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OrdersPage()),
          );
        },
        child: Text(_getButtonText()),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value.toString(), // Convert value to string
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Function to update the status
  Future<void> _updateStatus() async {
    String newStatus = '';
    if (status == 'baru') {
      newStatus = 'diproses';
    } else if (status == 'diproses') {
      newStatus = 'siap disajikan';
    } else if (status == 'siap disajikan') {
      newStatus = 'diproses';
    }
    final supabase = Supabase.instance.client;
    await supabase
        .from('transaksi')
        .update({'status': newStatus})
        .eq('idtransaksi', widget.transaction['idtransaksi'])
        .select();
  }

  // Function to get the button text based on the current status
  String _getButtonText() {
    if (status == 'baru') {
      return 'Proses Pesanan';
    } else if (status == 'diproses') {
      return 'Pesanan Siap';
    } else if (status == 'siap disajikan') {
      return 'Batalkan Status';
    }
    // Add more conditions for other status texts if needed
    return 'Ubah Status';
  }
}
