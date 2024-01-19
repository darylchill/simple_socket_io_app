import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketConn extends ChangeNotifier{

  Socket initSocketConn(){
     Socket socket = io('http://localhost:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()  // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build()
    );
    socket.connect();

    return socket;
  }

  void sendMessage(String message){
    Socket socket = initSocketConn();
    socket.connect().emit('chat message', message);
  }

}
