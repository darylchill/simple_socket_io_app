import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketio_sample/socketStream.dart';
import 'package:socketio_sample/socket_conn.dart';

void main() {
  runApp(
      MultiProvider(
        providers:[
          ChangeNotifierProvider(create:(_)=>SocketConn()),
        ],
        child:const MyApp(),

  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController txtMessageController = TextEditingController();
  StreamSocket streamSocket = StreamSocket();
  SocketConn socketConn = SocketConn();

  void sendMessage(String message) => context.read<SocketConn>().sendMessage(message);

  @override
  void initState() {
    // TODO: implement initState
    streamSocket.connectAndListen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          StreamBuilder<String>(
            stream: streamSocket.getResponse,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (kDebugMode) {
                  print(snapshot.data);
                }
                List<Widget> children;
                if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                  ];
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      children = const <Widget>[
                        Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 60,
                        ),
                      ];
                    case ConnectionState.waiting:

                      children = const <Widget>[
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Awaiting messages...'),
                        ),
                      ];
                    case ConnectionState.active:
                      children = <Widget>[
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('\$${snapshot.data}'),
                        ),
                      ];
                    case ConnectionState.done:
                      children = <Widget>[
                        const Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('\$${snapshot.data} (closed)'),
                        ),
                      ];
                  }
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                );
              },
            ),
            TextFormField(
              controller: txtMessageController,
              onFieldSubmitted: (value){
                txtMessageController.text = value;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendMessage(txtMessageController.text),
        tooltip: 'Send',
        child: const Icon(Icons.mail),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
