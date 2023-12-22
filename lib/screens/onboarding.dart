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
  bool shift1Selected = false;
  bool shift2Selected = false;

  // @override
  // void initState() {
  //   dropdownValue = list.first;
  //   super.initState();
  // }

  void _onIntroEnd(context) {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    const String shoppingSvg = 'assets/shopping.svg';
    const String cookingSvg = 'assets/cooking.svg';
    var list = <String>['Shift 1', 'Shift 2'].toList();
    String dropdownValue = list.first;

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
                  "Pilih shift terlebih dahulu",
                  style: TextStyle(fontSize: 18, color: Colors.black38),
                  textAlign: TextAlign.center,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownMenu<String>(
                      initialSelection: list.first,
                      width: 200,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      textStyle: const TextStyle(fontSize: 14),
                      menuStyle: const MenuStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      dropdownMenuEntries:
                          list.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FilledButton(
                      onPressed: dropdownValue != ''
                          ? () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('shift', dropdownValue);

                              _onIntroEnd(context);
                            }
                          : null,
                      child: const Text('Pilih Shift'),
                    )
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
}
