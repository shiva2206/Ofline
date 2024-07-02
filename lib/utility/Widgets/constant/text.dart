import 'package:flutter/material.dart';

import '../../Constants/color.dart';


const kTitleTextStyle = TextStyle(
  color: kGrey,
  fontSize: 16.5,
  fontWeight: FontWeight.w700,
  letterSpacing: 1,
);

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(textAlign: TextAlign.center, TextSpan(
      text: 'By continuing, you agree to our', style: TextStyle(
      color: kGrey,
    ),
      children: <InlineSpan>[
        TextSpan(
          text: ' Privacy policy', style: TextStyle(color: kBlue)
        ),
        TextSpan(text: ' and'),
        TextSpan(text: ' Terms of services', style: TextStyle(color: kBlue)),

        TextSpan(text: '.')
      ]
    ));
  }
}
