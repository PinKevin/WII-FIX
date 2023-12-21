import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionDetailPage extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late String status;

  @override
  void initState() {
    super.initState();
    // Set the initial status from the transaction data
    status = widget.transaction['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
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
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Call a function to update the status
          _updateStatus();
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value.toString(), // Convert value to string
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Function to update the status
  void _updateStatus() async {
    String newStatus = '';
    if (status == 'baru') {
      newStatus = 'diproses';
    } else if (status == 'diproses') {
      newStatus = 'siap disajikan';
    }
    // Lakukan pembaruan status di database menggunakan Supabase
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
    }
    // Add more conditions for other status texts if needed
    return 'Ubah Status';
  }
}
