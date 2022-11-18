import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'weather.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<dynamic, dynamic> weather = {};
  bool daynight() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    return (hour >= 6) && (hour <= 18);
  }

  Future<Map<dynamic, dynamic>> getweather() async {
    bool serviceEnabled;
    var position;
    var response;
    String city_name='';
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      city_name = 'bangalore';
    }else{
      position=await Geolocator.getCurrentPosition();
    }
    print(position);
    print(position.latitude.toString());
    String weather_key = '56696014b1b0f79692a93ba0ec757061';
    if (position!=null){
      response = await http.get(Uri.https(
          'api.openweathermap.org',
          '/data/2.5/weather',
          {'lat': position.latitude.toString(), 'lon': position.longitude.toString(),'appid':weather_key, 'units': 'metric'}));
    }else{
      response = await http.get(Uri.https(
          'api.openweathermap.org',
          '/data/2.5/weather',
          {'q': city_name, 'appid': weather_key, 'units': 'metric'}));
    }
    String jsonweather = response.body;
    weather = jsonDecode(jsonweather);
    return weather;
  }

  Future<Map<dynamic, dynamic>> getnews() async {
    var response;
    int length;
    Map<dynamic, dynamic> news = {};
    Map<dynamic, dynamic> newsstuff = {};
    String newsapi_key = 'ea9935cfc536478dabb3e120b106f258';
    response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country='+'IN'+'&apiKey='+newsapi_key+'&sortBy=relevancy'));
    String jsonnews = response.body;
    news = jsonDecode(jsonnews);
    return news;
  }

  @override
  Widget build(BuildContext context) {
    bool ifday = daynight();
    Color bgcolor;
    if (ifday) {
      bgcolor = Colors.white;
    } else {
      bgcolor = Color(0xff1e212a);
    }
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final weather = snapshot.data as Map<dynamic, dynamic>;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => secondpage(weather: weather)));

                          },
                            child: Container(
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
                            )
                        ),
                      ]);
                }
              },
              future: getweather(),
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final news = snapshot.data as Map<dynamic, dynamic>;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                                            Text(
                                              '${news['articles'][0]['title']}',
                                              style: TextStyle(fontSize: 35),
                                            ),
                                            Text(
                                                '${news['articles'][0]['url']}'
                                            ),
                        CarouselSlider(
                          options: CarouselOptions(height:  300),
                          items: ['lol','lol1','lol2','lol3','lol4'].map((i) {
                            return Builder(
                                builder : (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin : EdgeInsets.symmetric(horizontal: 5.0),

                                    child: Column(
                                      children: [
                                        Image.asset(i),
                                        SizedBox( height:  10,),
                                        if(i == 'lol')
                                          Text("lol1", style:  TextStyle( fontSize: 25, fontWeight: FontWeight.w800),),
                                        if(i == 'lol1')
                                          Text("lol2", style:  TextStyle( fontSize: 25, fontWeight: FontWeight.w800),),
                                        if(i == 'lol2')
                                          Text("lol3", style:  TextStyle( fontSize: 25, fontWeight: FontWeight.w800),),
                                        if(i == 'lol3')
                                          Text("lol4", style:  TextStyle( fontSize: 25, fontWeight: FontWeight.w800),),
                                        if(i == 'lol4')
                                          Text("lol5", style:  TextStyle( fontSize: 25, fontWeight: FontWeight.w800),),
                                      ],
                                    ),

                                  );
                                }
                            );
                          }).toList(),

                        ),
                                          ],

                      );
                }
              },
              future: getnews(),
            ),

          ]
        )

      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


