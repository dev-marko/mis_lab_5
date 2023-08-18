import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import '../services/location_service.dart';
import '../widgets/app_drawer.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  static const finkiLat = 42.00442180882685;
  static const finkiLng = 21.408809063322657;
  late GoogleMapController mapController;
  final _locationService = LocationService();
  final _controller = Completer();
  final _initialPin = const LatLng(finkiLat, finkiLng);
  final _markers = <Marker>{};
  final _polygons = <Polygon>{};
  final _polylines = <Polyline>{};
  var _polygonIdCounter = 1;
  List<LatLng> polygonLatLngs = <LatLng>[];
  Map<String, dynamic> selectedPlace = {};

  @override
  void initState() {
    super.initState();
    _setMarker(_initialPin);
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(point.toString()),
          position: point,
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;
    _polygons.add(
      Polygon(
          polygonId: PolygonId(polygonIdVal),
          points: polygonLatLngs,
          strokeWidth: 2,
          fillColor: Colors.black12),
    );
  }

  Future<void> _goToLocation(Map<String, dynamic> location) async {
    if (location.isEmpty) return;

    final GoogleMapController controller = await _controller.future;

    double latitude = location['geometry']['location']['lat'];
    double longitude = location['geometry']['location']['lng'];

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
      ),
    );

    _setMarker(
      LatLng(latitude, longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Location'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    child: TextField(
                      onSubmitted: (query) async {
                        if (query.isNotEmpty) {
                          selectedPlace =
                              await _locationService.getLocation(query);
                          _goToLocation(selectedPlace);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search for a location...',
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context, selectedPlace),
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point) {
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
              initialCameraPosition: CameraPosition(
                target: _initialPin,
                zoom: 20.0,
              ),
              markers: _markers,
            ),
          )
        ],
      ),
    );
  }
}
