import 'dart:io';

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
  runApp(ProviderScope(child: MaterialApp(home: MyHomePage())));
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



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.app/share');
  String _imageFilePath = '';

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'receiveImage':
        setState(() {
          _imageFilePath = call.arguments;
        });
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Receiver'),
      ),
      body: Center(
        child: _imageFilePath.isEmpty
            ? Text('Waiting for image...')
            : Image.file(
                File(_imageFilePath),
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Text('Failed to load image: $_imageFilePath');
                },
              ),
      ),
    );
  }
}