import 'package:flutter/material.dart';
import 'package:gifs_app/ui/HomePage.dart';
import 'package:gifs_app/ui/gif_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      accentColor: Colors.white,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      )
    ),
    home: HomePage(),
  ));
}
