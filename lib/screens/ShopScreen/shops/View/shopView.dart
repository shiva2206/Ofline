import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ofline_app/screens/FavouriteScreen/viewModel/favoriteViewModel.dart';
import 'package:ofline_app/screens/ShopScreen/shops/View/shopCardView.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';
import 'package:ofline_app/utility/Widgets/animatedSearch/ViewModel/searchViewModel.dart';
import 'package:ofline_app/utility/Widgets/drawer/View/drawerView.dart';
import '../../../../utility/Constants/color.dart';
import '../../../../utility/Widgets/animatedSearch/View/animatedSearchView.dart';
import '../../../../utility/Widgets/appBar/View/appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ViewModel/shopViewModel.dart';

class Home_Body_Screen extends ConsumerStatefulWidget {
  const Home_Body_Screen({
    super.key,
  });

  @override
  ConsumerState<Home_Body_Screen> createState() => _Home_Body_ScreenState();
}

class _Home_Body_ScreenState extends ConsumerState<Home_Body_Screen> {
  @override
  void initState() {
    super.initState();
  }

  Future<HashSet<String>> fetchFavoriteShopIds() async {
    final firestore = FirebaseFirestore.instance;
    final customerId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final shopIdsSnapshot = await firestore
          .collection('Customer')
          .doc(customerId)
          .collection('Favorites')
          .doc(customerId)
          .get();

      if (!shopIdsSnapshot.exists) {
        return HashSet(); // Return an empty HashSet if document doesn't exist
      }

      final List<dynamic> shopIdsList = shopIdsSnapshot['fav_shop'] ?? [];
      final HashSet<String> shopIdsHashSet =
          HashSet.from(shopIdsList.map((e) => e.toString()));

      return shopIdsHashSet;
    } catch (e) {
      print("Error fetching favorite shop IDs: $e");
      return HashSet(); // Return an empty HashSet in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;

    final shopListAsyncValue =
        ref.watch(shopListProvider(ref.watch(searchTextProvider)));
    final favShopListAsyncValue = ref.watch(favoriteShopIdsProvider);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kWhite,
            appBar: const MyAppBar(
              title: MySearchBar(hintext: 'Search'),
            ),
            drawer: CustomDrawer(mqw: mqw, mqh: mqh,),
            body: RefreshIndicator(
              onRefresh: () async {
                await ref.read(locationServiceProvider).fetchAndSetLocation();
              },
              color: kBlue,
              backgroundColor: kWhite,
              child: shopListAsyncValue.when(data: (shops) {
                return favShopListAsyncValue.when(data: (favShops) {
                  return ListView.builder(
                      itemCount: shops.length,
                      itemBuilder: (BuildContext context, int index) {
                        final shop = shops[index];
                        return ShopCard(
                            key: ValueKey(shop.id),
                            shop: shop,
                            mqh: mqh,
                            mqw: mqw,
                            isFavourite: favShops.contains(shop.id));
                      });
                }, error: (error, stackTrace) {
                  return Center(child: Text('Error: $error'));
                }, loading: () {
                  return const CircularProgressIndicator(
                      color: Colors.transparent);
                });
              }, error: (error, stackTrace) {
                return Center(child: Text('Error: $error'));
              }, loading: () {
                return const CircularProgressIndicator(
                    color: Colors.transparent);
              }),
            )));
  }
}
