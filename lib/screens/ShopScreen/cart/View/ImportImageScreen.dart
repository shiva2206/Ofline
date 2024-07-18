
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:uuid/uuid.dart';


// class ImportingImage extends StatefulWidget {
//   @override
//   _ImportingImageState createState() => _ImportingImageState();
// }

// class _ImportingImageState extends State<ImportingImage> {
//   static const platform = MethodChannel('com.example.app/share');
//   String _imageFilePath = '';
//   String _sourceApp = '';
//   String _status = '';
//   String _extractedAmount = '';
//   String _extractedDateTime = '';

//   @override
//   void initState() {
//     super.initState();
//     platform.setMethodCallHandler(_handleMethod);
//   }

//   Future<void> _handleMethod(MethodCall call) async {
//     switch (call.method) {
//       case 'receiveImage':
//         final Map<dynamic, dynamic> arguments = call.arguments;
//         setState(() {
//           _imageFilePath = arguments['filePath'] ?? '';
//           _sourceApp = arguments['sourceApp'] ?? 'Unknown';
//         });
//         _extractTextFromImage();
//         break;
//       default:
//         print('Unknown method ${call.method}');
//     }
//   }

//   Future<void> _extractTextFromImage() async {
//     if (_imageFilePath.isEmpty) return;

//     final inputImage = InputImage.fromFilePath(_imageFilePath);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final recognizedText = await textRecognizer.processImage(inputImage);

//     String fullText = '';
//     for (TextBlock block in recognizedText.blocks) {
//       for (TextLine line in block.lines) {
//         fullText += line.text + '\n';
//       }
//     }

//     print("--------------------");
//     print(fullText);
//     print("--------------------");

//     _status = _checkPaymentStatus(fullText);
//     _extractedAmount = _extractAmount(fullText);
//     _extractedDateTime = _extractDateTime(fullText);

//     setState(() {});

//     textRecognizer.close();
//   }

//   String _checkPaymentStatus(String text) {
//     final successKeywords = ['Successful', 'paid', 'completed'];
//     for (var keyword in successKeywords) {
//       if (text.toLowerCase().contains(keyword.toLowerCase())) {
//         return 'Yes';
//       }
//     }
//     return 'No';
//   }

//  String _extractAmount(String text) {
//   // Regular expression to match currency amounts without relying on the currency symbol
//   final regex = RegExp(r'[\₹\Rs\$.]*\s?\d+(,\d{3})*(\.\d{1,2})?');
//   final match = regex.firstMatch(text);
//   if (match != null) {
//     String recognizedText = match.group(0) ?? '';

//     // Post-processing to handle common OCR misrecognitions, assuming '7' is often misrecognized for '₹'
//     recognizedText = recognizedText.replaceAll('7', '₹');

//     return recognizedText;
//   }
//   return 'Amount not found';
// }


//  String _extractDateTime(String text) {
//   final regex = RegExp(
//     r'(\d{1,2}\s(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{2,4}),?\s?(\d{1,2}:\d{2}\s(?:AM|PM)?)?|(\d{1,2}:\d{2}\s(?:AM|PM))\s(?:on)?\s(\d{1,2}\s(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{2,4})',
//     caseSensitive: false
//   );
//   final match = regex.firstMatch(text);
//   if (match != null) {
//     // Build the date time string from parts
//     String datePart = match.group(1) ?? match.group(4) ?? '';
//     String timePart = match.group(2) ?? match.group(3) ?? '';
//     return (datePart + ' ' + timePart).trim();
//   }
//   return 'Date not found';
// }


//   Future<void> uploadImageAndSaveLink() async {
//     try {
//       String uniqueId = Uuid().v4();
//       File imageFile = File(_imageFilePath);

//       // Upload to Firebase Storage
//       FirebaseStorage storage = FirebaseStorage.instance;
//       Reference ref = storage.ref().child('paymentImage');
//       UploadTask uploadTask = ref.putFile(imageFile);
//       TaskSnapshot taskSnapshot = await uploadTask;
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();

//       // Update Firestore
//       String customerId = 'customer_id'; // Replace with your actual customer ID
//       String shopId = 'shop_id'; // Replace with your actual shop ID

//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       QuerySnapshot query = await firestore
//           .collection('Cart')
//           .where('customer_id', isEqualTo: customerId)
//           .where('shop_id', isEqualTo: shopId)
//           .get();

//       if (query.docs.isNotEmpty) {
//         String cartId = query.docs.first.id;
//         await firestore
//             .collection('Cart')
//             .doc(cartId)
//             .update({'cart_payment_image': downloadUrl});
//       } else {
//         print('No matching cart found');
//       }
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Receiver'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _imageFilePath.isEmpty
//                 ? const Text('Waiting for image...')
//                 : Image.file(
//                     File(_imageFilePath),
//                     errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
//                       return Text('Failed to load image: $_imageFilePath');
//                     },
//                   ),
//             const SizedBox(height: 20),
//             Text(
//               'Received from: ${_sourceApp == "com.google.android.apps.nbu.paisa.user" ? "GPay" : _sourceApp}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Payment Status: $_status',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Extracted Amount: $_extractedAmount',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Extracted Date and Time: $_extractedDateTime',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

