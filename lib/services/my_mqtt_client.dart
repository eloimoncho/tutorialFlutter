import "dart:io";

import "package:flutter/material.dart";
import "package:mqtt_client/mqtt_client.dart";
import "package:mqtt_client/mqtt_server_client.dart";


enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState { IDLE, SUBSCRIBED }

class MQTTClientWrapper extends ChangeNotifier {
  List<String>listaValueMensajes = [];
  
  MqttServerClient client = MqttServerClient.withPort(
    '3b36b1a9f1744afba0f41671d1040340.s1.eu.hivemq.cloud', 
    'prueba_flutter', 
    8883);

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  Future<bool> connectMqttClient() async {
    _setupMqttClient();
    return await _connectClient();
  }

  Future<bool> _connectClient() async {
    try {
      print('client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect('eloimoncho', 'mqttTEST1');

      //await client.connect();
    } on Exception catch (e) {
      print('client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
      return false;
    }

    // when connected, print a confirmation, else print an error
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('client connected');
      return true;
    } else {
      print(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
      return false;
    }
  }
  void _setupMqttClient() {
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 60;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print('OnConnected client callback - Client connection was sucessful');

    //Nos suscribimos a los tópicos necesarios
    //client.subscribe('writeParameters', MqttQos.atLeastOnce);
    client.subscribe('Value', MqttQos.atLeastOnce);
    //client.subscribe('videoFrame', MqttQos.atLeastOnce);
    
    //publishMessage('', 'Connect');
    //publishMessage('', 'getValue');

    // print the message when it is received
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      var message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    
      if (c[0].topic == 'Value') listaValueMensajes.add(message);
    /*  if (c[0].topic == 'videoFrame') {
        lastVideoFrame = message;
        notifyListeners();
      }
    */ 
      print('YOU GOT A NEW MESSAGE:');
      print(message);
    });
  }

  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;

    /*if (topic == 'Value' && !_subscriptionCompleter.isCompleted) {
      _subscriptionCompleter.complete();
    }*/
  }
}

