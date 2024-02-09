import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socketio_sample/socket_conn.dart';

// STEP1:  Stream setup
class StreamSocket{
  final _socketResponse= StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void connectAndListen(){
    Socket socket = SocketConn().initSocketConn();

    socket.onConnect((_) {
      if (kDebugMode) {
        print('connect');
      }
    });

    //When an event received from server, data is added to the stream
    socket.on('chat message', (data) {
      addResponse(data);
      if (kDebugMode) {
        print("Message: $data");
      }
    });
    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('disconnect');
      }
    });

  }

  void dispose(){
    _socketResponse.close();
  }
}

