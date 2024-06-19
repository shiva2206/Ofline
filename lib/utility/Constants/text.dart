import 'package:flutter/material.dart';

import 'color.dart';

const kTitleTextStyle = TextStyle(
    color: kGrey,
    fontWeight: FontWeight.w700,
    fontSize: 16.5,
    letterSpacing: 1);
class termsofservices extends StatelessWidget {
  const termsofservices({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  const Text.rich(textAlign:TextAlign.center,TextSpan(
        text: 'By continuing, you agree to our',
        style: TextStyle(
          color: kGrey,
        ),
        children: <InlineSpan>[
          TextSpan(text: ' Privacy policy', style: TextStyle(color: kBlue)),
          TextSpan(
            text: ' and ',
          ),
          TextSpan(text: ' Terms of services', style: TextStyle(color: kBlue)),

          TextSpan(text: '.')
        ])
      // textAlign: TextAlign.center,
    );
  }
}
