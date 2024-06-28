import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/FavouriteScreen/viewModel/favoriteViewModel.dart';
import 'package:ofline_app/screens/ShopScreen/shops/View/shopCardView.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../auth/View/authView.dart';
import '../../../utility/Constants/color.dart';
import '../../../utility/Widgets/appBar/View/aapbar.dart';
import '../../../utility/Widgets/drawer/View/about.dart';
import '../../ShopScreen/shops/View/shopView.dart';

class Favourite_Screen extends ConsumerStatefulWidget {
  const Favourite_Screen({super.key});

  @override
  ConsumerState<Favourite_Screen> createState() => _Favourite_ScreenState();
}

class _Favourite_ScreenState extends ConsumerState<Favourite_Screen> {
  final bool _isEnabled = false;

  // var loc = const Home_Body_Screen();

  get address => null;

  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    final favShopListAsyncValue = ref.watch(favoriteShopsProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
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
                      'IIT Madras, Chennai',
                      style:  TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: kGrey),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      const urlPreview =
                          'hhttps://play.google.com/store/apps/details?id=in.liiia.user';

                      await Share.share('Liaa : Local Market \n$urlPreview');
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
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: kGrey),
                      ),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.youtube_searched_for,
                      color: kGrey,
                      size: 20.5,
                    ),
                    title: Text(
                      'YouTube',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: kGrey),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launch('mailto:contact@liaa.in');
                    },
                    child: const ListTile(
                      leading: Icon(
                        Icons.mail_outline_outlined,
                        color: kGrey,
                        size: 20.5,
                      ),
                      title: Text(
                        'Contact',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: kGrey),
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
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: kGrey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mqh * 110 / 2340,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: mqw * 180 / 1080),
                    child: GestureDetector(
                      onTap: () {
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
                              'Log Out',
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
          ),
          backgroundColor: kWhite,
          appBar: const MyAppBar(
              title: Text('Favourite',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: kBlue))),
          body: favShopListAsyncValue.when(data: (favShops){ 
            
            return ListView.builder(
                    itemCount: favShops.length,
                    itemBuilder: (BuildContext context, int index
                        ) {
                      final shop = favShops[index];
                      return ShopCard(key:ValueKey(shop.id),shop: shop, mqh: mqh, mqw: mqw,isFavourite: true,); });}, error: (error, stackTrace) {
                return Center(child: Text('Error: $error'));
              }, loading: (){return const CircularProgressIndicator(color: Colors.transparent);})
          ),
        ),
    
    );
  }
}
