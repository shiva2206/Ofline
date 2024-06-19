import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

// LocationState class to hold latitude and longitude
class LocationState {
  final double? latitude;
  final double? longitude;

  LocationState({this.latitude, this.longitude});
}

// LocationNotifier class to manage location state
class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  void setLocation(double latitude, double longitude) {
    state = LocationState(latitude: latitude, longitude: longitude);
  }
}

// Provider for LocationNotifier
final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});

