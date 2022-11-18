import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'weather.dart';

class secondpage extends StatefulWidget {
  final Map<dynamic, dynamic> weather;
  const secondpage({Key? key, required this.weather})
      : super(key: key);

  @override
  State<secondpage> createState() => _secondpageState(weather);
}

class _secondpageState extends State<secondpage> {
  final Map<dynamic, dynamic> weather;
  _secondpageState(this.weather);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1e212a),
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
          child: Column(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: ShapeDecoration(
                            shape: StadiumBorder(), color: Colors.greenAccent),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            '${weather['main']['temp']}°C',
                                            style: TextStyle(fontSize: 35),
                                          ),
                                          Image(
                                              image: AssetImage(
                                                  'assets/${weather['weather'][0]['icon']}.png')),
                                        ],
                                      )),
                                  Text('${weather['weather'][0]['main']}',
                                      style: TextStyle(fontSize: 30)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      'Min: ${weather['main']['temp_min']}°C',
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                      'Max: ${weather['main']['temp_max']}°C',
                                      style: TextStyle(fontSize: 18))
                                ],
                              )
                            ]),
                      ),
                      Container(
                        height: 300,
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                bottomRight: Radius.circular(40.0),
                                topLeft: Radius.circular(40.0),
                                bottomLeft: Radius.circular(40.0)),
                            color: HexColor('#4C4f69').withOpacity(0.7)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Humidity: ${weather['main']['humidity']}%',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white)),
                                    Text(
                                        'Wind: ${(weather['wind']['speed'] * 180 / 5).round() / 10} km/h',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white))
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Pressure: ${weather['main']['pressure']} hPa',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white)),
                                    Text(
                                        'Wind: ${weather['wind']['deg']} °',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white))
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Sunrise: ${DateTime.fromMillisecondsSinceEpoch(weather['sys']['sunrise']*1000).hour}:${DateTime.fromMillisecondsSinceEpoch(weather['sys']['sunrise']*1000).minute}',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white)),
                                    Text(
                                        'Sunset: ${DateTime.fromMillisecondsSinceEpoch(weather['sys']['sunset']*1000).hour}:${DateTime.fromMillisecondsSinceEpoch(weather['sys']['sunset']*1000).minute}',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white))
                                  ]),
                            ]),
                      ),
                    ]

                ),
              ]
          )

      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}