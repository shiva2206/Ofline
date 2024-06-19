import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ofline_app/screens/BNB.dart';
import 'package:ofline_app/utility/Constants/color.dart';
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
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
                  }
                }
                return const Center(child: CircularProgressIndicator(color: kBlue,));
          })

          // AuthenticationPage(),
        ),

      ),
    );
  }
}
