import 'package:flutter/material.dart';

import '../Constants/color.dart';

class ArrowbackIcon extends StatelessWidget {
  const ArrowbackIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.arrow_back,
      color: kGrey,
      size: 22.5,
    );
  }
}

GestureDetector arrowbackmethod(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: const ArrowbackIcon(),
  );
}
