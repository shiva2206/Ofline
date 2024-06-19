import 'package:flutter/material.dart';

import '../../../Constants/color.dart';


class User_Profile extends StatefulWidget {
  const User_Profile({super.key});

  @override
  State<User_Profile> createState() => _User_ProfileState();
}

// ignore: camel_case_types
class _User_ProfileState extends State<User_Profile> {
  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            'Profile',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 18, color: kBlue),
          ),
        )),
        backgroundColor: kWhite,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: mqh * 25 / 230,
            ),
            Padding(
              padding:  EdgeInsets.only(left: mqw*200/1080, right: mqw*90/1080, top: mqh*200/2340),
              child: const Text('Shine Jaiswal',style: TextStyle(color: kGrey, fontWeight: FontWeight.w500,fontSize: 17),),
            ),
            SizedBox(
              height: mqh * 10 / 230,
            ),
            Padding(
              padding:  EdgeInsets.only(left: mqw*200/1080, right: mqw*90/1080, top: mqh*30/2340),
              child: const Text('22 years',style: TextStyle(color: kGrey, fontWeight: FontWeight.w500,fontSize: 17),),
            ),
            SizedBox(
              height: mqh * 10 / 230,
            ),
            Padding(
              padding:  EdgeInsets.only(left: mqw*200/1080, right: mqw*90/1080, top: mqh*30/2340),
              child: const Text('Male',style: TextStyle(color: kGrey, fontWeight: FontWeight.w500,fontSize: 17),),
            ),
            SizedBox(
              height: mqh * 10 / 230,
            ),
            Padding(
              padding:  EdgeInsets.only(left: mqw*200/1080, right: mqw*90/1080, top: mqh*30/2340),
              child: const Text('8529453681',style: TextStyle(color: kGrey, fontWeight: FontWeight.w500,fontSize: 17),),
            ),
            SizedBox(
              height: mqh * 15 / 230,
            ),
            Padding(
              padding:  EdgeInsets.only(left: mqw*860/1080, top: mqh*300/2340),
              child: const Icon(Icons.edit, color: kGrey,size: 22,),
            )
          ],
        ),
      ),
    );
  }
}
