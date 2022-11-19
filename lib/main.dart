import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'weather.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'newspage.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String searchtext='';
  final myController = TextEditingController();
  @override
  void textdispose() {
    myController.dispose();
    super.dispose();
  }

  void textsetValue() {
    searchtext = myController.text;
  }

  void heightinitState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(textsetValue);
  }
  _launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Map<dynamic, dynamic>> getweather() async {
    bool serviceEnabled;
    var position;
    var response;
    String city_name = '';
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
    } else {
      position = await Geolocator.getCurrentPosition();
    }
    print(position);
    print(position.latitude.toString());
    String weather_key = '56696014b1b0f79692a93ba0ec757061';
    if (position != null) {
      response = await http
          .get(Uri.https('api.openweathermap.org', '/data/2.5/weather', {
        'lat': position.latitude.toString(),
        'lon': position.longitude.toString(),
        'appid': weather_key,
        'units': 'metric'
      }));
    } else {
      response = await http.get(Uri.https(
          'api.openweathermap.org',
          '/data/2.5/weather',
          {'q': city_name, 'appid': weather_key, 'units': 'metric'}));
    }
    String jsonweather = response.body;
    weather = jsonDecode(jsonweather);
    return weather;
  }

  Future<List<dynamic>> getnews() async {
    var response;
    Map<dynamic, dynamic> news = {};
    int len;
    List<int> stuff=[];
    List<dynamic> url_data = [];
    List<dynamic> title_data = [];
    List<dynamic> image_data = [];
    String newsapi_key = 'ea9935cfc536478dabb3e120b106f258';
    response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=' +
            'IN' +
            '&apiKey=' +
            newsapi_key +
            '&sortBy=relevancy'));
    print('https://newsapi.org/v2/top-headlines?country=' +
        'IN' +
        '&apiKey=' +
        newsapi_key +
        '&sortBy=relevancy');
    String jsonnews = response.body;
    news = jsonDecode(jsonnews);
    if (news['articles'].length>10){
      len=10;
    } else {
      len=news['articles'].length;
    }
    for (int i = 0; i < len; i++) {
      url_data += [news['articles'][i]['url']];
      title_data += [news['articles'][i]['title']];
      stuff+=[i];
      if(news['articles'][i]['urlToImage']!=null){
        image_data += [news['articles'][i]['urlToImage']];
      }else{
        image_data += ['https://www.analyticdesign.com/wp-content/uploads/2018/07/unnamed-574x675.gif'];
      }

    }
    print(image_data);
    List<dynamic> newsdata = [url_data, title_data, image_data, stuff];
    return newsdata;
  }

  @override
  Widget build(BuildContext context) {
    Color bgcolor;
    bgcolor = Color(0xff1e212a);
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row( mainAxisAlignment: MainAxisAlignment.center,
                    children:[
          SizedBox(
          height: 50,
              width: 300,
                  child:
                  TextField(
                      style: TextStyle(color: Colors.white),
                      controller: myController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Search'),
                      onChanged: (text) {
                        setState(() {
                          {
                            searchtext = text;
                          }
                        });
                      }),),
                  ElevatedButton(onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                newspage(search: searchtext)));
                  }, child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ))
                ]),

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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          secondpage(weather: weather)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(30),
                              decoration: ShapeDecoration(
                                  shape: StadiumBorder(),
                                  color: Colors.greenAccent),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                            )),
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
                  final news = snapshot.data as List<dynamic>;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 400, width: 400, child: CarouselSlider(
                          options: CarouselOptions(height: 400),
                          items: (news[3]).map<Widget>((i){
                            return Builder(
                                builder: (BuildContext context){
                                  return GestureDetector(
                                      child: Container(
                                              child: Text(news[1][i],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                    backgroundColor: Colors.white,

                                              ),),
                                              margin: EdgeInsets.all(6.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0),
                                                image: DecorationImage(
                                                  image: NetworkImage(news[2][i]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                    onTap: (){_launchURL(news[0][i]);},


                                          );

                                }
                            );
                          }).toList())),
                    ],
                  );
                }
              },
              future: getnews(),
            ),
          ])),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
