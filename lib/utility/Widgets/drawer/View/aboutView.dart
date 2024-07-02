import 'package:flutter/material.dart';
import '../../../Constants/color.dart';


class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhite,
        appBar: (AppBar(
          elevation: 0,
          backgroundColor: kWhite,
          bottomOpacity: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: kGrey,
              size: 20,
            ),
          ),
          leadingWidth: mqw * 200 / 1080,
          title: const Text(
            'About',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 18, color: kBlue),
          ),
        )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: mqw * 100 / 1080,
                  right: mqw * 95 / 1080,
                  top: mqh * 35 / 2340),
              child: SizedBox(
                height: mqh * 500 / 2340,
                width: mqw * 970 / 1080,
                child: const Text(
                  'Ofline is an local marketplace app and it is operating under the company name of _________. whose CIN is ________. We are right now serving only in restaurant category. This is our pilot test in the campus of IIT Madras. Please give us feedback to improve our services for you.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: kGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            SizedBox(height: mqh*600/2340),

            Padding(
              padding:  EdgeInsets.only(left: mqw*100/1080),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Text('Privacy policy.', style: TextStyle(color: kBlue, fontWeight: FontWeight.w500, fontSize: 15),),
                  SizedBox(height: mqh*25/2340),
                  const Text('Terms of services.', style: TextStyle(color: kBlue, fontWeight: FontWeight.w500, fontSize: 15),),
                  SizedBox(height: mqh*25/2340),

                ],),
            ),
          ],
        ),
      ),
    );
  }
}
