import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.lightBlue),
    darkTheme: ThemeData.dark(),
    home: HomePage(
      title: 'HOME',
    ),
  ));
}
