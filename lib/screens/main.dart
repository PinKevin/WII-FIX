import 'package:flutter/material.dart';
import 'package:wii/main.dart';
import 'package:wii/screens/dashboard.dart';
import 'package:wii/screens/orders.dart';
import 'package:wii/screens/profile.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  Future<List<Map<String, dynamic>>> _getTransactions() async {
    final response = await supabase.from('transaksi').select(
          'idtransaksi, shift, status, kodemeja, namapelanggan, total, metodepembayaran, waktu, tanggal',
        );

    List<Map<String, dynamic>> transactions = response.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        // indicatorColor: Colors.purple,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            selectedIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: FutureBuilder<List<Map<String, dynamic>>>(
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

                  var count = transactions!
                      .where((transaction) => transaction['status'] == 'baru')
                      .length;

                  return Badge(
                    label: Text(count.toString()),
                    child: Icon(Icons.shopping_cart_outlined),
                  );
                }
              },
            ),
            icon: FutureBuilder<List<Map<String, dynamic>>>(
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

                  var count = transactions!
                      .where((transaction) =>
                          transaction['status'] == 'baru' ||
                          transaction['status'] == 'diproses')
                      .length;

                  return Badge(
                    label: Text(count.toString()),
                    child: Icon(Icons.shopping_cart_outlined),
                  );
                }
              },
            ),
            label: 'Orders',
          ),
          const NavigationDestination(
            selectedIcon: Badge(
              child: Icon(Icons.account_circle_rounded),
            ),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        // Card(
        //   shadowColor: Colors.transparent,
        //   margin: const EdgeInsets.all(8.0),
        //   child: SizedBox.expand(
        //     child: Center(
        //       child: Text(
        //         'Home page',
        //         style: theme.textTheme.titleLarge,
        //       ),
        //     ),
        //   ),
        // ),

        const DashboardPage(),

        const OrdersPage(),

        const ProfilePage(),
      ][currentPageIndex],
    );
  }
}
