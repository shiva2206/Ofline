import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:ofline_app/screens/BNB.dart';
import 'package:ofline_app/screens/ShopScreen/carts/View/CartView.dart';
import 'package:ofline_app/screens/ShopScreen/carts/View/CustomBottomSheet.dart';
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
  runApp( ProviderScope(child: MaterialApp(home: SplashScreen(),)));
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
                      // return Custombottomsheet(shop: sp, customerId: "z2hoSD4BzcNev0tSCmT3mQYnxPz2");
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

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Start navigation after the first frame is drawn
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => Ofline()),
          );
        }
      });
    });

    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child:const  Icon(
            Icons.shopping_cart,
            size: 100.0, // Adjust the size of the icon as needed
            color: kBlue, // Adjust the color of the icon as needed
          ),
        ),
      ),
    );
  }
}
