import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier{
  late IO.Socket socket;
  late BuildContext _context;

  void setContext(BuildContext context){
    _context = context;
  }

  void initSocket(){
    IO.Socket socket = IO.io('http://192.168.1.63:5000', <String, dynamic>{
      'transports':['websocket'],
    });
    socket.onConnecting((data) => print('Conectando'));
    socket.onConnectError((data) => print('error en la conexión: $data'));
    socket.onConnect((_) {
      socket.emit('connectPlatform');
      print('Connect');
    });
    socket.onDisconnect((_) => print('Diconnect'));
    socket.on('connected', (data) {_showAlertDialog('Mensaje recibido: $data');});
  }

  void _showAlertDialog(String message){
    showDialog(
      context: _context, 
      builder: (context) =>AlertDialog(
          title: const Text('Mensaje del servidor'),
          content: Text(message),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('Cerrar')),
          ]
        )
      );

  }
}