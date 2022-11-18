import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'weather.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:intl/intl.dart';

class newspage extends StatefulWidget {
  final String search;
  const newspage({Key? key, required this.search}) : super(key: key);

  @override
  State<newspage> createState() => _newspageState(search);
}

class _newspageState extends State<newspage> {

  final String search;
  _newspageState(this.search);
  @override
  Future<List<dynamic>> getnews() async {
    final DateTime now = DateTime.now();
    final String year =  DateFormat('yyyy').format(now);
    final String month =  (int.parse(DateFormat('mm').format(now))-1).toString();
    final String day= DateFormat('dd').format(now);
    final String date=year+'-'+month+'-'+day;
    var response;
    Map<dynamic, dynamic> news = {};
    int len;
    List<dynamic> url_data = [];
    List<dynamic> title_data = [];
    List<dynamic> image_data = [];
    String newsapi_key = 'ea9935cfc536478dabb3e120b106f258';
    response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everthing?q=' +
            search.replaceAll(' ', '%20') +
            '&apiKey=' +
            newsapi_key +'&from='+date+
            '&sortBy=relevancy'));
    String jsonnews = response.body;
    news = jsonDecode(jsonnews);
    if (news.length>5){
      len=5;
    } else {
      len=news.length;
    }
    for (int i = 0; i < len; i++) {
      url_data += [news['articles'][i]['url']];
      title_data += [news['articles'][i]['title']];
      image_data += [news['articles'][i]['urlToImage']];
    }
    List<dynamic> newsdata = [url_data, title_data, image_data];
    return newsdata;
  }
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
                FutureBuilder(
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      final news = snapshot.data as List<dynamic>;
                      print(news);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CarouselSlider(
                              options: CarouselOptions(height: 300),
                              items: [
                                Container(
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(news[2][0]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                //2nd Image of Slider
                                Container(
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(news[2][1]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                //3rd Image of Slider
                                Container(
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(news[2][2]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                //4th Image of Slider
                                Container(
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(news[2][3]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                //5th Image of Slider
                                Container(
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(news[2][4]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(news[1][4])
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      );
                    }
                  },
                  future: getnews(),
                ),
              ]),]))
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
