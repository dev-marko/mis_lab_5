import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

class Location with ChangeNotifier {
  final String name;
  final String address;
  final LatLng coordinates;

  Location({
    required this.name,
    required this.address,
    required this.coordinates,
  });

  @override
  String toString() {
    return name;
  }
}
