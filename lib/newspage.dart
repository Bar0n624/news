import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'weather.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';

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
  Widget build(BuildContext context) {
    return Container();
  }
}
