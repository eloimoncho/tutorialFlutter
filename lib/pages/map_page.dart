import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoiZWxvaW1vbmNobyIsImEiOiJjbHN0OTBpbmwweXg3Mmpxa3hzYXp4MTRqIn0.unS27qTvHsSX7RikaFOCyQ';
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  List<Marker> markers = [];
  List<Polyline> polylines= [];

  void _onMapTapped(TapPosition tapPosition, LatLng latLng){
    setState(() {
      markers.add(Marker(
        width:80,
        height: 80,
        point: latLng,
        child: Transform.translate(
          offset: const Offset(0, -16),
          child: const Icon(
            Icons.location_on,
            size:40,
            color: Colors.red,
            ),
        )
      ));
      if(markers.length > 1){
        polylines.add(Polyline(
          points:[
            markers[markers.length-2].point,
            markers[markers.length-1].point,
          ],
          strokeWidth: 2.0,
          color: Colors.amber,    
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan, 
        title: const Text('Map'),
        actions:[
          IconButton(onPressed: (){
            setState(() {
              if(markers.isNotEmpty){
                markers.removeLast();
                if(polylines.isNotEmpty){
                  polylines.removeLast();
                }
              }
            });
          }, 
          icon: const Icon(Icons.backspace_outlined)),

        ]
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: const LatLng(41.275946, 1.987475),
          minZoom: 1,
          maxZoom: 20,
          initialZoom: 15,
          interactionOptions: InteractionOptions(enableMultiFingerGestureRace: true),
          onTap: _onMapTapped,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id':'mapbox/satellite-streets-v12',
            },
          ),
          MarkerLayer(
            markers: [...markers]
            ),
          PolylineLayer(polylines: [...polylines])
        ],
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.indigo,
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: Icon(Icons.clear_sharp),
            label: 'Delete route',
            onTap: () {
              setState(() {
                markers.clear();
                polylines.clear();
              });
            },
          )],
      ),
    );
  }
}