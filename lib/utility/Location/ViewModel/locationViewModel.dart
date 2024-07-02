import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

final startPointProvider = Provider.family<LatLng, UserLocation>((ref, coor) {
  // Define your start geopoint
  return LatLng(coor.latitude, coor.longitude);
});

final endPointProvider = Provider.family<LatLng, UserLocation>((ref, coor) {
  // Define your end geopoint
  return LatLng(coor.latitude, coor.longitude);
});