import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

// Define a data class to hold location data
class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});
}

