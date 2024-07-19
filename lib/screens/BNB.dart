import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/cart/Model/CartModel.dart';
import 'package:ofline_app/screens/ShopScreen/products/View/productView.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/Constants/color.dart';
import 'FavouriteScreen/View/favouriteView.dart';
import 'HistoryScreen/View/historyView.dart';
import 'ShopScreen/shops/View/shopView.dart';


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class BnbLessScreen extends ConsumerStatefulWidget {
  const BnbLessScreen({super.key});



  @override
  ConsumerState<BnbLessScreen> createState() => _BnbLessScreenState();
}

class _BnbLessScreenState extends ConsumerState<BnbLessScreen> with WidgetsBindingObserver{

  static const platform = MethodChannel('com.example.app/share');
  String _imageFilePath = '';
  String _sourceApp = '';
  String _status = '';
  String _extractedAmount = '';
  String _extractedDateTime = '';

  int myIndex = 0;

  List<Widget> bnbScreen = [
    const Home_Body_Screen(),
    const Favourite_Screen(),
      // History_Screen(customerId: FirebaseAuth.instance.currentUser!.uid,)
      History_Screen(customerId: "z2hoSD4BzcNev0tSCmT3mQYnxPz2",)
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     WidgetsBinding.instance.addObserver(this);
    print("----------init State---------");
    platform.setMethodCallHandler(_handleMethod);

  }

  @override
  void dispose() {
    // TODO: implement dispose
     WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
  
   
      

     
      if (state == AppLifecycleState.resumed) {
       
        print("--------resumed-------");

        platform.setMethodCallHandler(_handleMethod);
      }
  }

  
  Future<void> _handleMethod(MethodCall call) async {
    print("============world======");
    switch (call.method) {
      case 'receiveImage':
        final Map<dynamic, dynamic> arguments = call.arguments;
        setState(() {
          _imageFilePath = arguments['filePath'] ?? '';
          _sourceApp = arguments['sourceApp'] ?? 'Unknown';
        });
        uploadImageAndSaveLink();
        print("-----------cominnnnggg");
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


  Future<void> uploadImageAndSaveLink() async {
    try {
      String uniqueId = Uuid().v4();
      File imageFile = File(_imageFilePath);

      // Upload to Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('paymentImage/${uniqueId}');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Update Firestore
      String customerId = FirebaseAuth.instance.currentUser!.uid; // Replace with your actual customer ID

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? shopId = await prefs.getString("shopId");
      // if(shopId==null){
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(
      //           content: Text('ShopId is not present!'),
      //           backgroundColor: Colors.red,
      //         ),
      //       );
      //     return ;
      // }
      // shopId = 'oMRTytXxid2EuJij2O8r'; // Replace with your actual shop ID
      
      FirebaseFirestore firestore = FirebaseFirestore.instance;
       DocumentSnapshot doc = await firestore.collection("Shop").doc(shopId).get();
        ShopModel shop = ShopModel.fromFirestore(doc);

    

      QuerySnapshot query = await firestore
          .collection('Cart')
          .where('customer_id', isEqualTo: customerId)
          .where('shop_id', isEqualTo: shopId)
          .get();

      if (query.docs.isNotEmpty) {
        String cartId = query.docs.first.id;

        Cartmodel cartmdel = await Cartmodel.fromFirestore(query.docs.first);
        if(cartmdel.cart_payment_image!=""){
          // await deleteImageFromStorage(cartmdel.cart_payment_image);
        }
        await firestore
            .collection('Cart')
            .doc(cartId)
            .update({'cart_payment_image': downloadUrl});

       
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Product_Screen(shop: shop, startingYear: shop.startingYear,toCart:true)));
      } else {
        print('No matching cart found');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

//   Future<void> deleteImageFromStorage(String url) async {
//   // Parse the URL
//      String relativePath = getUrlRelativePath(url);
//                     print(relativePath);
//                     Reference refer = FirebaseStorage.instance.ref().child(relativePath);
//                     await refer.delete();
//                     print('File deleted successfully');
// }
// String getUrlRelativePath(String fullUrl) {
//     Uri uri = Uri.parse(fullUrl);
//     String path = uri.pathSegments.skip(4).join('/');
//     return Uri.decodeFull(path);
//   }

 
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
              label: 'Pre-order',
            ),
          ],
        ),
      ),
      // body: ,
    );
  }
}


