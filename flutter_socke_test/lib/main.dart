import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

// const Colors :
const kprimary = Color(0xFF23C58E);

const kcolor1 = Color(0xFF202226);

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      primaryColor: kprimary,
    ),
    title: 'MyDht11',
    home: Scaffold(
      appBar: AppBar(
        title: Text('My Home'),
        centerTitle: true,
      ),
      body: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String temperature = '';
  String humidity = '';

  var addressesIListenFrom = InternetAddress.ANY_IP_V4;

  int portIListenOn = 5005; //0 is random

  Future<void> socketUdp() async {

    String messages, temp = '';
    String hum = '';

    var jsonDecoder;

    await RawDatagramSocket.bind(addressesIListenFrom, portIListenOn)
        .then((RawDatagramSocket udpSocket) {
      udpSocket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.READ) {
          Datagram dg = udpSocket.receive();
          messages = utf8.decode(dg.data);
          print(messages);
          jsonDecoder = jsonDecode(messages);
          temp = jsonDecoder["temp"];
          hum = jsonDecoder["hum"];
        }
        setState(() {
          temperature = temp+" C°";
          humidity = hum+" %";
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketUdp();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: MyCards(
                  cardChild: DataCards(
                    measurement: 'Humidity',
                    data: humidity,
                  ),
                )),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                    child: MyCards(
                  cardChild: DataCards(
                    measurement: 'Temperature',
                    data: temperature,
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MyCards(
                    cardChild: Text('Battery'),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: MyCards(
                    cardChild: Text('Battery'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: MyCards(
                  cardChild: Text('Graphe'),
                ))
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: MyCards(
                  cardChild: RawMaterialButton(
                    onPressed: null,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text(
                        'OFF',
                        style: TextStyle(color: kprimary, fontSize: 20.0),
                      ),
                    ),
                    shape: Border.all(
                      color: kprimary,
                    ),
                  ),
                )),
              ],
            )
          ],
        ));
  }
}

class MyCards extends StatelessWidget {
  MyCards({this.cardChild});

  final Widget cardChild;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kcolor1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
        child: cardChild,
      ),
    );
  }
}

class DataCards extends StatelessWidget {
  DataCards({this.data, this.measurement});

  final String data;
  final String measurement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [Text('$measurement')],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DataCircle(data: data),
          ],
        )
      ],
    );
  }
}

class DataCircle extends StatelessWidget {
  DataCircle({this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(0, 0),
      children: <Widget>[
        Container(
            width: 120,
            height: 120,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: kprimary,
            )),
        Container(
            width: 100,
            height: 100,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: kcolor1,
            )),
        Text(
          '$data',
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
