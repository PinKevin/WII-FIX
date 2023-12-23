import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  DateTime? selectedDate;

  // @override
  // void initState() {
  //   dropdownValue = list.first;
  //   super.initState();
  // }

  void _onIntroEnd(context) async {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    const String shoppingSvg = 'assets/shopping.svg';
    const String cookingSvg = 'assets/cooking.svg';
    var list = <String>['Shift 1', 'Shift 2'].toList();
    String dropdownValue = '';

    return IntroductionScreen(
      bodyPadding: const EdgeInsets.all(0),
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      pages: [
        PageViewModel(
          title: "Warmindo Inspirasi Indonesia",
          bodyWidget: const Text(
            "Selamat Datang di Warmindo Inspirasi Indonesia",
            style: TextStyle(fontSize: 18, color: Colors.black38),
            textAlign: TextAlign.center,
          ),
          image: Container(
            padding: const EdgeInsets.only(
                top: 100, bottom: 50, left: 25, right: 25),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(64),
              ),
            ),
            width: double.infinity,
            height: double.infinity,
            child: SizedBox(
              width: 200,
              height: 200,
              child: SvgPicture.asset(
                shoppingSvg,
                semanticsLabel: 'Acme Logo',
                placeholderBuilder: (BuildContext context) => Container(
                  width: 200,
                  padding: const EdgeInsets.all(30.0),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
        PageViewModel(
          title: "Warmindo Inspirasi Indonesia",
          bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Pilih tanggal dan shift anda terlebih dahulu",
                  style: TextStyle(fontSize: 16, color: Colors.black38),
                  textAlign: TextAlign.center,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.purple.shade50),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                      ),
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              side: BorderSide(
                                  color: Colors.purple.shade100, width: 1),
                            ),
                            onPressed: () => _selectDate(context),
                            child: Text(selectedDate != null
                                ? 'Tanggal: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'
                                : 'Pilih tanggal'),
                          ),
                          const SizedBox(height: 20),
                          DropdownMenu<String>(
                            inputDecorationTheme: InputDecorationTheme(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.purple, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.purple, width: 1),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                            ),
                            initialSelection: list.first,
                            width: 200,
                            onSelected: (String? value) async {
                              setState(() {
                                dropdownValue = value!;
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setInt(
                                'shift',
                                value.toString() == 'Shift 1' ? 1 : 2,
                              );
                            },
                            textStyle: const TextStyle(fontSize: 14),
                            menuStyle: const MenuStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                            ),
                            dropdownMenuEntries: list
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        _onIntroEnd(context);
                      },
                      child: const Text('Pilih Shift'),
                    ),
                  ],
                ),
              ]),
          image: Container(
            padding: const EdgeInsets.only(
                top: 100, bottom: 50, left: 25, right: 25),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(64)),
            ),
            width: double.infinity,
            height: double.infinity,
            child: SizedBox(
              width: 200,
              height: 200,
              child: SvgPicture.asset(
                cookingSvg,
                semanticsLabel: 'Acme Logo',
                placeholderBuilder: (BuildContext context) => Container(
                  width: 200,
                  padding: const EdgeInsets.all(30.0),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ],
      // skipOrBackFlex: 0,
      // nextFlex: 0,
      next: const Text(
        'Lanjut',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.purple,
          fontSize: 16,
        ),
      ),
      nextStyle: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
      ),
      // done: const Text(
      //   'Selesai',
      //   style: TextStyle(
      //     fontWeight: FontWeight.w600,
      //     color: Colors.purple,
      //     fontSize: 16,
      //   ),
      // ),
      controlsPadding: const EdgeInsets.all(24),
      showDoneButton: false,
      dotsDecorator: const DotsDecorator(
        size: Size.square(8),
        activeShape: OvalBorder(),
        activeColor: Colors.black,
        activeSize: Size.square(14),
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('date', pickedDate.toString());
    }
  }
}
