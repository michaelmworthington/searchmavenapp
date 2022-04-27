import 'package:flutter/material.dart';

import 'pages/home_page/home_page_scaffold_advanced_search.dart';
import 'pages/home_page/home_page_scaffold_quick_search.dart';

void main() {
  //TODO: config option for debugging & control output (NOTE: search all files for print()
  //TODO: uncomment for prod builds
  //      https://stackoverflow.com/questions/49475550/how-to-disable-all-logs-debugprint-in-release-build-in-flutter
  //debugPrint = (String message, {int wrapWidth}) {};
  runApp(const MyApp());
}

//The Scaffolding and Look-and-Feel Theme for the app
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Maven App',
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      theme: _buildTheme(),
      home: const MyHomePage(title: 'Search Maven App'),
    );
  }
}

ThemeData _buildTheme() {
  return ThemeData(
    primarySwatch: Colors.blueGrey,
    //canvasColor: Colors.blueGrey,
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    buttonColor: Colors.blueGrey,
    buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
    //iconTheme: IconThemeData(
    //  color: Colors.red
    //),
    //bottomAppBarColor: Colors.red,
    //cardColor: Colors.red
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//This class defines a build() method
//which defines the layout for the Home Page
class _MyHomePageState extends State<MyHomePage> {
  // TODO: REMOVE once I'm comfortable with setState()
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // ignore: unused_local_variable
      const int counter = 0;
    });
  }

  //from:
  //    - ./res/layout/main.xml
  //    - ./src/com/searchmavenapp/android/maven/search/activities/Main.java
  //    - ./res/layout/main_advanced_search.xml
  //    - ./src/com/searchmavenapp/android/maven/search/activities/MainAdvancedSearch.java
  //https://flutter.io/docs/cookbook/design/drawer
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: "Quick Search"),
                Tab(text: "Advanced Search"),
              ],
            )),
        body: const TabBarView(
          children: <Widget>[
            HomePageScaffoldQuickSearch(),
            HomePageScaffoldAdvancedSearch(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
