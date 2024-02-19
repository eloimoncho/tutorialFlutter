import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial/services/my_mqtt_client.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isReceiving = false;
  Uint8List? backgroundImage;

  Uint8List decodeAndShow(String frame){
    Uint8List image = base64Decode(frame);
    backgroundImage = image;
    return image;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Page'),
        backgroundColor: Colors.cyan,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if(isReceiving == false){
                    Provider.of<MQTTClientWrapper>(context, listen: false).publishMessage('', 'StartVideoStream');
                  }
                  else{
                    Provider.of<MQTTClientWrapper>(context, listen: false).publishMessage('', 'StopVideoStream');
                  }
                  setState(() {
                      isReceiving = !isReceiving;
                    });
                },
                child: Container(
                  width: 100,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.amber, 
                    borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      isReceiving ? 'Detener video' : 'Iniciar video',
                      style: const TextStyle(color: Colors.white),
                    ),
                ),
              ),
              const SizedBox(height: 30),
              Consumer<MQTTClientWrapper>(
                builder: (context, value, child) {
                  return AspectRatio(aspectRatio: 4/3,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: [
                      if(backgroundImage != null)
                        Image.memory(backgroundImage!, fit: BoxFit.cover),
                      if(value.lastVideoFrame.isNotEmpty)Image.memory(decodeAndShow(value.lastVideoFrame), fit: BoxFit.cover ,)
                    ]),
                    ),
                  );
                },
              )
            ],
          )
        ),
      )
    );
  }
}