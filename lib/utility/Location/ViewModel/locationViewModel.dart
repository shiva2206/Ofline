import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';


class LocationService {
  final Location _location = Location();

  Stream<LocationData?> getLocationStream() async* {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        yield null;
        return;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        yield null;
        return;
      }
    }
    print(_location.onLocationChanged);
    print("shiva prasad");
    yield* _location.onLocationChanged;
  }
}


final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final locationStreamProvider = StreamProvider<LocationData?>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.getLocationStream();
});