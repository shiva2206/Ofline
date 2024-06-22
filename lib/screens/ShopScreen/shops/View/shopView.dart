import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:ofline_app/screens/ShopScreen/shops/View/shopCardView.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';
import 'package:ofline_app/utility/Widgets/animatedSearch/ViewModel/searchViewModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../auth/View/authView.dart';
import '../../../../utility/Constants/color.dart';
import '../../../../utility/Widgets/animatedSearch/View/animatedSearchView.dart';
import '../../../../utility/Widgets/appBar/View/aapbar.dart';
import '../../../../utility/Widgets/drawer/View/about.dart';
import '../../../../utility/Location/Model/locationModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/View/productView.dart';
import '../ViewModel/shopViewModel.dart';



class Home_Body_Screen extends ConsumerStatefulWidget {
  const Home_Body_Screen({super.key});

  @override
  ConsumerState<Home_Body_Screen> createState() => _Home_Body_ScreenState();
}

class _Home_Body_ScreenState extends ConsumerState<Home_Body_Screen> {

    @override
  void initState() {
    super.initState();
  
  }


  int _favNumber = 0;
  bool _favourite = false;
  void _favInc() {
    setState(() {
      _favNumber++;
    });
  }
  void _favDec() {
    setState(() {
      _favNumber--;
    });
  }




  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    // final location = ref.watch(locationServiceProvider);
    final shopListAsyncValue = ref.watch(shopListProvider(ref.watch(searchTextProvider)));
    // final locate = ref.watch(loca);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kWhite,
            appBar: const MyAppBar(
              title: MySearchBar(hintext: 'Search'),
            ),
            drawer: buildDrawer(mqw, mqh, context),
            body: shopListAsyncValue.when(data: (shops) {
              return ListView.builder(
                  itemCount: shops.length,
                  itemBuilder: (BuildContext context, int index
                      ) {
                    final shop = shops[index];
                    return ShopCard(shop: shop, mqh: mqh, mqw: mqw); });
            }, error: (error, stackTrace) {
              return Center(child: Text('Error: $error'));
            }, loading: () {
              return const CircularProgressIndicator(color: Colors.transparent);
            })));
  }


  Drawer buildDrawer(double mqw, double mqh, BuildContext context) {
    return Drawer(
      width: mqw * 630 / 1080,
      backgroundColor: kWhite,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mqw * 10 / 1080),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mqw * 48 / 1080),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: mqw * 149 / 1080,
                    height: mqh * 90 / 2340,
                  ),
                  const Text(
                    'Ofline',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: kBlue),
                  ),
                  SizedBox(
                    height: mqh * 160 / 2340,
                  ),
                ],
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.location_on_outlined,
                color: kGrey,
                size: 20.5,
              ),
              title: Text(
                "",
                // lokation.address,
                style:  TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500, color: kGrey),
              ),
            ),
            GestureDetector(
              onTap: () async {
                const urlPreview =
                    '';

                await Share.share('Ofline : Local Market \n$urlPreview');
              },
              child: ListTile(
                leading: Icon(
                  Icons.share,
                  color: kGrey.withOpacity(0.60),
                  size: 19,
                ),
                title: const Text(
                  'Share App',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500, color: kGrey),
                ),
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.subscriptions_outlined,
                color: kGrey,
                size: 19.5,
              ),
              title: Text(
                'YouTube',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500, color: kGrey),
              ),
            ),
            GestureDetector(
              onTap: () {
                launch('mailto:oflineshine@gmail.com');
              },
              child: const ListTile(
                leading: Icon(
                  Icons.mail_outline_outlined,
                  color: kGrey,
                  size: 19,
                ),
                title: Text(
                  'Contact',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500, color: kGrey),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutScreen()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.info_outline_rounded,
                  color: kGrey,
                  size: 20,
                ),
                title: Text(
                  'About',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500, color: kGrey),
                ),
              ),
            ),
            SizedBox(
              height: mqh * 110 / 2340,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mqw * 180 / 1080),
              child: GestureDetector(
                onTap: () async {
                  await GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthenticationPage()));
                },
                child: Container(
                  height: mqh * 0.045,
                  width: mqw * 160 / 1080,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(27)),
                      color: kBlue),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
