import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart' as LatLon;

class UsersLocations extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String name;

  const UsersLocations({super.key, required this.latitude, required this.longitude,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text("$name Location"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: flutter_map.FlutterMap(
        options: flutter_map.MapOptions(
          initialCenter: LatLon.LatLng(latitude, longitude),
          initialZoom: 15,
        ),
        children: [
          // Map Tiles
          flutter_map.TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'com.example.app',
            retinaMode: flutter_map.RetinaMode.isHighDensity(context),
          ),
          flutter_map.MarkerLayer(
            markers: [
              flutter_map.Marker(
                point: LatLon.LatLng(latitude, longitude),
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
