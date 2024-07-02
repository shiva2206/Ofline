import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/BNB.dart';
import '../../utility/Constants/color.dart';
import '../../utility/Constants/text.dart';
import '../../utility/Location/ViewModel/locationViewModel.dart';
import '../Model/google_auth.dart';


class AuthenticationPage extends ConsumerStatefulWidget {
  const AuthenticationPage({super.key});

  @override
  ConsumerState<AuthenticationPage> createState() => _AuthenticationPageState();
}


class _AuthenticationPageState extends ConsumerState<AuthenticationPage> {


  // LokationPage lokation = LokationPage();



  @override
  void initState() {
    // TODO: implement initState
    // lokation.getLatLong();
    super.initState();
    final locationService = ref.read(locationServiceProvider);
    locationService.fetchAndSetLocation();
  }

  @override
  Widget build(BuildContext context) {
    var mqh = MediaQuery.of(context).size.height;
    var mqw = MediaQuery.of(context).size.width;
    
    // final locationState = ref.watch(locationProvider);
    // final locationNotifier = ref.read(locationProvider.notifier);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhite,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: mqh * 90 / 2340,
            ),
            DefaultTextStyle(
              style: const TextStyle(
                  fontSize: 30.0, color: kBlue, fontWeight: FontWeight.w800),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TyperAnimatedText('Ofline',
                      speed: const Duration(microseconds: 200000)),
                ],
                isRepeatingAnimation: true,
              ),
            ),
            SizedBox(
              height: mqh * 700 / 2340,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                  height: mqh * 70 / 2340,
                  width: mqw * 66.5 / 1080,
                  child: const Image(
                      image: AssetImage('images/Google icon.png'))),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.of(context, rootNavigator: true).push(
                    // MaterialPageRoute(
                    //     maintainState: true,
                    //     builder: (context) => const BnbLessScreen()));
                AuthMethods().signInWithGoogle(context);

              },
              child: Container(
                height: mqh * 0.049,
                width: mqw * 600 / 1080,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: kBlue),
                child: Padding(
                  padding: EdgeInsets.all(mqw * 10 / 1080),
                  child: Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: mqw * 50 / 1080),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Local market',
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: kWhite,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: mqh * 900 / 2340,
                  left: mqw * 35 / 1080,
                  right: mqw * 35 / 1080,
                  bottom: mqh * 10 / 2340,
                  // top: _mediaQuery.size.height * 400 / 2340,
                ),
                child: const termsofservices()
                // textAlign: TextAlign.center,
                ),
          ],
        ),
      ),
    );
  }
}


