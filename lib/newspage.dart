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
import 'package:url_launcher/url_launcher.dart';

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
  _launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<List<dynamic>> getnews() async {
    final DateTime now = DateTime.now();
    final String year =  DateFormat('yyyy').format(now);
    print(DateFormat('MM').format(now));
    final String month =  (int.parse(DateFormat('MM').format(now))-1).toString();
    print(month);
    final String day= DateFormat('dd').format(now);
    final String date=year+'-'+month+'-'+day;
    var response;
    Map<dynamic, dynamic> news = {};
    int len;
    List<int> stuff=[];
    List<dynamic> url_data = [];
    List<dynamic> title_data = [];
    List<dynamic> image_data = [];
    String newsapi_key = 'ea9935cfc536478dabb3e120b106f258';
    response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=' +
            search.replaceAll(' ', '%20') +
            '&apiKey=' +
            newsapi_key +'&from='+date+
            '&sortBy=relevancy'));
    String jsonnews = response.body;
    news = jsonDecode(jsonnews);
    if (news['articles'].length>10){
      len=10;
    } else {
      len=news['articles'].length;
    }
    for (int i = 0; i < len; i++) {
      stuff+=[i];
      url_data += [news['articles'][i]['url']];
      title_data += [news['articles'][i]['title']];
      if(news['articles'][i]['urlToImage']!=null){
        image_data += [news['articles'][i]['urlToImage']];
      }else{
        image_data += ['https://www.analyticdesign.com/wp-content/uploads/2018/07/unnamed-574x675.gif'];
      }}
    List<dynamic> newsdata = [url_data, title_data, image_data, stuff];
    print(newsdata);
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
                          }).toList()))
                          ,
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
