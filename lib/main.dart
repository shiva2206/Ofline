import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:ofline_app/screens/BNB.dart';
import 'package:ofline_app/screens/ShopScreen/carts/View/CartView.dart';
import 'package:ofline_app/screens/ShopScreen/products/View/productView.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Constants/color.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';
import 'auth/View/authView.dart';
import 'utility/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kWhite,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: kWhite,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(const ProviderScope(child: Ofline()));
}
class Ofline extends ConsumerStatefulWidget {
  const Ofline({super.key});
  @override
  ConsumerState<Ofline> createState() => _OflineState();
}
class _OflineState extends ConsumerState<Ofline> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final locationService = ref.read(locationServiceProvider);
    locationService.fetchAndSetLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color:kWhite,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: kWhite,
            body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.hasError){
                    return Text(snapshot.hasError.toString());
                  }
                  if(snapshot.connectionState == ConnectionState.active){
                    if (snapshot.data == null){
                      return const AuthenticationPage();
                    }
                    else {
                      return const BnbLessScreen();
                      // ShopModel sp = new ShopModel(id: "oMRTytXxid2EuJij2O8r", shop_name: "ok shine", shopImageLink: "", address: "", isOpen: true, latitude: 12, longitude: 80, startingYear: "1998", fav_count: 0, views:0, isActivated: true, live_view: 0, date: "12-3-2023");
                      // return Cartview(shop: sp, customerId: "z2hoSD4BzcNev0tSCmT3mQYnxPz2");
                    }
                  }
                  return const Center(child: CircularProgressIndicator(color: kBlue,));
            })
        
            // AuthenticationPage(),
          ),
        
        ),
      ),
    );
  }
}
