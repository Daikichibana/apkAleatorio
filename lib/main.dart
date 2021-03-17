import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    Random random = new Random();
    int randomNumber = random.nextInt(1000);
    setState(() {
      _counter = randomNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<String> sendData() async {
      var dateTime = DateTime.now();
      var val = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(dateTime);
// There is no timezone data associated with DateTime, so you have to use the following code to get the timezone info
      var offset = dateTime.timeZoneOffset;
      var hours = offset.inHours > 0
          ? offset.inHours
          : 1; // For fixing divide by zero error
      if (!offset.isNegative) {
        val = val +
            "+" +
            offset.inHours.toString().padLeft(2, '0') +
            ":" +
            (offset.inMinutes % (hours * 60)).toString().padLeft(2, '0');
      } else {
        val = val +
            offset.inHours.toString().padLeft(2, '0') +
            ":" +
            (offset.inMinutes % (hours * 60)).toString().padLeft(2, '0');
      }
      print(val);
      var response =
          await http.post(Uri.https('apidoble.azurewebsites.net', '/api/data'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                "Random": '$_counter',
                "DateTime": val,
              }));

      setState(() {
        _counter = 0;
      });

      return response.body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              'Numero random:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: sendData, child: new Text("Enviar datos")),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
