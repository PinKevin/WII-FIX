import 'package:flutter/material.dart';
import 'package:wii/components/bottom_app_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool shift1Selected = false;
  bool shift2Selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WII'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  shift1Selected = true;
                  shift2Selected = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: shift1Selected
                    ? MaterialStateProperty.all(Colors.blue)
                    : MaterialStateProperty.all(Colors.transparent),
              ),
              child: const Text('Shift 1'),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  shift1Selected = false;
                  shift2Selected = true;
                });
              },
              style: ButtonStyle(
                backgroundColor: shift2Selected
                    ? MaterialStateProperty.all(Colors.blue)
                    : MaterialStateProperty.all(Colors.transparent),
              ),
              child: const Text('Shift 2'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: (shift1Selected || shift2Selected)
                    ? () {
                        print('Halo');
                      }
                    : null,
                child: const Text('Pilih Shift'))
          ],
        )),
        bottomNavigationBar: BottomBar.showBottomAppBar(context));
  }
}
