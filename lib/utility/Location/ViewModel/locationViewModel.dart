// import 'dart:ffi';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:location/location.dart';


// class LocationService {
//   final Location _location = Location();

//   Stream<LocationData?> getLocationStream() async* {
//     bool serviceEnabled = await _location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _location.requestService();
//       if (!serviceEnabled) {
//         yield null;
//         return;
//       }
//     }

//     PermissionStatus permissionGranted = await _location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         yield null;
//         return;
//       }
//     }
//     print(_location.onLocationChanged);
//     print("shiva prasad");
//     yield* _location.onLocationChanged;
//   }
// }


// final locationServiceProvider = Provider<LocationService>((ref) {
//   return LocationService();
// });

// final locationStreamProvider = StreamProvider<LocationData?>((ref) {
//   final locationService = ref.watch(locationServiceProvider);
//   return locationService.getLocationStream();
// });


// final locationProvider = Provider<List<double>>((ref){
//   return [0.0,0.0];
// });


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:ofline_app/utility/Location/Model/locationModel.dart';


class LocationService {
  final Ref ref;
  LocationService({required this.ref});

  Future<void> fetchAndSetLocation() async {
    Location location = Location();

    // Check if location service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // Check for location permissions
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get current location
    LocationData locationData = await location.getLocation();

    // Update the state provider with the new location
    ref.read(locationProvider.notifier).state = UserLocation(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(ref: ref);
});

final locationProvider = StateProvider<UserLocation?>((ref) {
  return null; // Initial state is null
});