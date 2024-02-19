import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoiZWxvaW1vbmNobyIsImEiOiJjbHN0OTBpbmwweXg3Mmpxa3hzYXp4MTRqIn0.unS27qTvHsSX7RikaFOCyQ';
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan, 
        title: const Text('Map'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: const MapOptions(
          initialCenter: LatLng(41.275946, 1.987475),
          minZoom: 1,
          maxZoom: 20,
          initialZoom: 15,
          interactionOptions: InteractionOptions(enableMultiFingerGestureRace: true),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id':'mapbox/satellite-streets-v12',
            },
          )
        ],
      ),
    );
  }
}