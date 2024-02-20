import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

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
  List<Marker> savedMarkers = [];
  List<Polyline> savedPolylines= [];

  void _cargarDesdeServidor()async{
    try{
      final response = await http.get(Uri.parse('http://192.168.1.63:4000/data'));
      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);
        if(data.isNotEmpty){
          print(data);
          List<dynamic> coordenadas = data[data.length -1];
          setState(() {
            markers = coordenadas.map((item) => Marker(point: LatLng(item['lat'], item['lng']), 
            child: Transform.translate(
              offset: const Offset(-5, -21),
              child: const Icon(
                Icons.location_on,
                size:40,
                color: Colors.red,
              ),
            )
          ),
          ).toList();

          polylines = [];
          for(int i = 1; i<markers.length;i++){
            polylines.add(
              Polyline(
                points: [
                  markers[i-1].point,
                  markers[i].point,
                ],
                strokeWidth: 2.0,
                color: Colors.amber,    
              ),
            );
          }
          });
        }
      }
    }
    catch(e){
      print('error al cargar $e');
    }
  }

  void _guardarDesdeServidor(List<dynamic> coordenadas) async{
    try{
      final response = await http.post(
        Uri.parse('http://192.168.1.63:4000/data'),
        headers: <String,String>{
          'Content-Type':'application/json; charset=UTF-8',
        },
        body: jsonEncode(coordenadas),
      );
      if(response.statusCode == 200){
        print('Coordenadas guardadas correctamente');
      }
      else{
        print('Error al guardar coordenadas');
      }
    }
    catch(e){
      print('error al guardar $e');
    }
  }

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
          interactionOptions: const InteractionOptions(enableMultiFingerGestureRace: true),
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
            child: const Icon(Icons.save_alt_sharp),
            label: 'Save route',
            onTap: () {
              setState(() {
                _guardarDesdeServidor(markers.map((marker) => {
                  'lat':marker.point.latitude,
                  'lng':marker.point.longitude,
                }).toList());
                savedMarkers = List.from(markers);
                savedPolylines = List.from(polylines);
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.upload_sharp),
            label: 'Load route',
            onTap: () {
              setState(() {
                _cargarDesdeServidor();
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.clear_sharp),
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