import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';

import '../utility/Constants/color.dart';
import 'FavouriteScreen/View/favouriteView.dart';
import 'HistoryScreen/View/historyView.dart';
import 'ShopScreen/shops/View/shopView.dart';


class BnbLessScreen extends ConsumerStatefulWidget {
  const BnbLessScreen({super.key});



  @override
  ConsumerState<BnbLessScreen> createState() => _BnbLessScreenState();
}

class _BnbLessScreenState extends ConsumerState<BnbLessScreen> {
  int myIndex = 0;

  List<Widget> bnbScreen = [
    const Home_Body_Screen(),
    const Favourite_Screen(),
    const History_Screen()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var mqh = MediaQuery.of(context).size.height;
    var mqw = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // body: IndexedStack(
      //   index: myIndex,
      //   children: bnbScreen,
      // ),
      body: bnbScreen[myIndex],
      backgroundColor: kWhite,
      bottomNavigationBar: SizedBox(
        height: mqh*185/2340,
        child: BottomNavigationBar(
          enableFeedback: true,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          selectedItemColor: kBlue,
          unselectedItemColor: kGrey.withOpacity(0.6),
          showSelectedLabels: true,
          selectedLabelStyle: const TextStyle(
              color: kBlue, fontWeight: FontWeight.w500, fontSize: 16),
          iconSize: 22,
          backgroundColor: kWhite,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.storefront,
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ],
        ),
      ),
      // body: ,
    );
  }
}


