import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/FavouriteScreen/viewModel/favoriteViewModel.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/screens/ShopScreen/shops/View/shopCardView.dart';
import 'package:ofline_app/utility/Widgets/drawer/View/drawerView.dart';
import '../../../utility/Constants/color.dart';
import '../../../utility/Widgets/appBar/View/appbar.dart';
class Favourite_Screen extends ConsumerStatefulWidget {
  const Favourite_Screen({super.key});

  @override
  ConsumerState<Favourite_Screen> createState() => _Favourite_ScreenState();
}

class _Favourite_ScreenState extends ConsumerState<Favourite_Screen> {
  final bool _isEnabled = false;

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
          drawer: CustomDrawer(mqw: mqw, mqh: mqh),
          backgroundColor: kWhite,
          appBar: const MyAppBar(
              title: Text('Favourite',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: kBlue))),
          body: favShopListAsyncValue.when(
            data: (shopStreams) {
              return ListView.builder(
                itemCount: shopStreams.length,
                itemBuilder: (BuildContext context, int index) {
                  final shopStream = shopStreams[index];
                  return StreamBuilder<ShopModel>(
                    stream: shopStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No Data'));
                      } else {
                        final shop = snapshot.data!;
                        return ShopCard(
                          key: ValueKey(shop.id + shop.fav_count.toString()),
                          shop: shop,
                          mqh: mqh,
                          mqw: mqw,
                          isFavourite: true,
                        );
                      }
                    },
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return Center(child: Text('Error: $error'));
            },
            loading: () {
              return const CircularProgressIndicator(color: Colors.transparent);
            },
          ),
        ),
      ),
    );
  }
}
