import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial/pages/menu_page.dart';
import 'package:tutorial/services/my_mqtt_client.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool isConnected = false;
  String titleButton = 'Conectar';
  Color colorButton = const Color.fromARGB(255, 44, 33, 243);
  
  void changeConnected(){
    isConnected = !isConnected;
    setState(() {
      if(isConnected == false){
      titleButton = 'Conectar';
      colorButton = const Color.fromARGB(255, 44, 33, 243);
      }
      else{
        titleButton = 'Desconectar';
        colorButton = const Color.fromARGB(212, 170, 0, 227);
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => const MenuPage(),
        ));
      }
    });  
  }

  void connectMQTT() async{
    if (isConnected == false) {
      bool canConnect =
          await Provider.of<MQTTClientWrapper>(context, listen: false)
              .connectMqttClient();
      if (canConnect) {
        changeConnected();
      } else {
        print('Error en la conexión');
      }
    } else {
      Provider.of<MQTTClientWrapper>(context, listen: false)
          .client
          .disconnect();
      changeConnected();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial Flutter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.cyan,
        
        ),
        body: Center(
          child: InkWell(
            onTap: connectMQTT,
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: colorButton,
                borderRadius: const BorderRadius.all(Radius.circular(120)),),
              child: Center(child: Text(titleButton, style: const TextStyle(color: Colors.white),)), 
          ),
          )
        )
    );
  }
}