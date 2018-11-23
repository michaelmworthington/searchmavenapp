import 'package:flutter/material.dart';
import 'package:searchmavenapp/pages/myhomepage.dart';

//The Scaffolding and Look-and-Feel Theme for the app
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Maven App',
      theme: _buildTheme(),
      home: MyHomePage(title: 'Search Maven App', storage: CounterStorage()),
    );
  }
}

ThemeData _buildTheme() {
  return ThemeData(
    primarySwatch: Colors.blueGrey,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder()
    )
  );
}
