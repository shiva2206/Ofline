// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:location/location.dart';
// import 'package:ofline_app/screens/ShopScreen/shops/View/shopView.dart';
// import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// // Assuming the LocationService and Providers have already been defined as previously mentioned

// class LocationStreamScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final locationAsyncValue = ref.watch(locationStreamProvider);


//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Stream'),
//       ),
//       body: Center(
//         child: locationAsyncValue.when(
//           data: (locationData) {

//             if (locationData == null) {
//               return Text('Location not available');
//             }
//             return const Home_Body_Screen(locationData);
//           },
//           loading: () => const CircularProgressIndicator(),
//           error: (error, stack) => Text('Error: $error'),
//         ),
//       ),
//     );
//   }
// }


