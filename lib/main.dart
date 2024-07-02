import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:ofline_app/screens/BNB.dart';
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.app/share');
  String _imageFilePath = '';
  String _sourceApp = '';
  String _status = '';
  String _extractedAmount = '';
  String _extractedDateTime = '';

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'receiveImage':
        final Map<dynamic, dynamic> arguments = call.arguments;
        setState(() {
          _imageFilePath = arguments['filePath'] ?? '';
          _sourceApp = arguments['sourceApp'] ?? 'Unknown';
        });
        _extractTextFromImage();
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_imageFilePath.isEmpty) return;

    final inputImage = InputImage.fromFilePath(_imageFilePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);

    String fullText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        fullText += line.text + '\n';
      }
    }

    print("--------------------");
    print(fullText);
    print("--------------------");

    _status = _checkPaymentStatus(fullText);
    _extractedAmount = _extractAmount(fullText);
    _extractedDateTime = _extractDateTime(fullText);

    setState(() {});

    textRecognizer.close();
  }

  String _checkPaymentStatus(String text) {
    final successKeywords = ['Successful', 'paid', 'completed'];
    for (var keyword in successKeywords) {
      if (text.toLowerCase().contains(keyword.toLowerCase())) {
        return 'Yes';
      }
    }
    return 'No';
  }

 String _extractAmount(String text) {
  // Regular expression to match currency amounts without relying on the currency symbol
  final regex = RegExp(r'[\₹\Rs\$.]*\s?\d+(,\d{3})*(\.\d{1,2})?');
  final match = regex.firstMatch(text);
  if (match != null) {
    String recognizedText = match.group(0) ?? '';

    // Post-processing to handle common OCR misrecognitions, assuming '7' is often misrecognized for '₹'
    recognizedText = recognizedText.replaceAll('7', '₹');

    return recognizedText;
  }
  return 'Amount not found';
}


 String _extractDateTime(String text) {
  final regex = RegExp(
    r'(\d{1,2}\s(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{2,4}),?\s?(\d{1,2}:\d{2}\s(?:AM|PM)?)?|(\d{1,2}:\d{2}\s(?:AM|PM))\s(?:on)?\s(\d{1,2}\s(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{2,4})',
    caseSensitive: false
  );
  final match = regex.firstMatch(text);
  if (match != null) {
    // Build the date time string from parts
    String datePart = match.group(1) ?? match.group(4) ?? '';
    String timePart = match.group(2) ?? match.group(3) ?? '';
    return (datePart + ' ' + timePart).trim();
  }
  return 'Date not found';
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Receiver'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFilePath.isEmpty
                ? const Text('Waiting for image...')
                : Image.file(
                    File(_imageFilePath),
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Text('Failed to load image: $_imageFilePath');
                    },
                  ),
            const SizedBox(height: 20),
            Text(
              'Received from: ${_sourceApp == "com.google.android.apps.nbu.paisa.user" ? "GPay" : _sourceApp}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Payment Status: $_status',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Extracted Amount: $_extractedAmount',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Extracted Date and Time: $_extractedDateTime',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifecycle Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lifecycle Demo'),
        ),
        body: Center(
          child: AppLifecycleLogger(),
        ),
      ),
    );
  }
}

class AppLifecycleLogger extends StatefulWidget {
  @override
  _AppLifecycleLoggerState createState() => _AppLifecycleLoggerState();
}

class _AppLifecycleLoggerState extends State<AppLifecycleLogger> with WidgetsBindingObserver {
  int count = 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _log('App initialized');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _log('App disposed');
    super.dispose();
  }

  void _log(String message) {
    print(message);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("-------------------------");
    _log('AppLifecycleState: $state');
    print("-------------------------");
  }

  @override
  Widget build(BuildContext context) {
    return Text('Check console for lifecycle logs');
  }
}