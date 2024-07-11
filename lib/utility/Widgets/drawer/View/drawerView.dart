import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Constants/color.dart';
import 'aboutView.dart';

class CustomDrawer extends StatefulWidget {
  final double mqw;
  final double mqh;

  CustomDrawer({
    required this.mqw,
    required this.mqh,
    Key? key,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Placemark? _userLocation;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied) {
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        setState(() {
          _userLocation = placemarks.first;
        });
      } else {
        throw Exception('Location permission not granted');
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: widget.mqw * 630 / 1080,
      backgroundColor: kWhite,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.mqw * 10 / 1080),
        child: ListView(
          children: [
            SizedBox(height: widget.mqh * 110 / 2340),
            ListTile(
              leading: Icon(
                Icons.location_on_outlined,
                color: kGrey,
                size: 20.5,
              ),
              title: _userLocation != null
                  ? Text(
                      _userLocation!.subLocality ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kGrey,
                      ),
                    )
                  : Text(
                      'Fetching...',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kGrey,
                      ),
                    ),
            ),
            GestureDetector(
              onTap: () async {
                const urlPreview = '';
                await Share.share('Ofline : Local Market \n$urlPreview');
              },
              child: ListTile(
                leading: Icon(
                  Icons.share,
                  color: kGrey.withOpacity(0.60),
                  size: 18.5,
                ),
                title: const Text(
                  'Share App',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: kGrey,
                  ),
                ),
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.subscriptions_outlined,
                color: kGrey,
                size: 18.6,
              ),
              title: Text(
                'YouTube',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: kGrey,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.history,
                color: kGrey,
                size: 20.5,
              ),
              title: Text(
                'History',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: kGrey,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
              child: const ListTile(
                leading: Icon(
                  Icons.info_outline_rounded,
                  color: kGrey,
                  size: 20,
                ),
                title: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: kGrey,
                  ),
                ),
              ),
            ),
            SizedBox(height: widget.mqh * 110 / 2340),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: widget.mqw * 180 / 1080),
              child: GestureDetector(
                onTap: () async {
                  await GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                  
                },
                child: Container(
                  height: widget.mqh * 0.045,
                  width: widget.mqw * 160 / 1080,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(27)),
                    color: kBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
