import 'package:flutter/material.dart';

import 'pages/home_page/home_page_navigation_drawer.dart';
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
    inputDecorationTheme:
        const InputDecorationTheme(border: const OutlineInputBorder()),
    buttonColor: Colors.blueGrey,
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //https://flutter.io/docs/cookbook/design/tabs
  //https://stackoverflow.com/questions/50123354/how-to-get-current-tab-index-in-flutter
  //https://www.youtube.com/watch?v=8x2Ssf5OxQ4
  static const List<Tab> myTabs = <Tab>[
    Tab(text: "Quick Search"),
    Tab(text: "Advanced Search"),
  ];

  static const List<Widget> myTabPages = <Widget>[
    HomePageScaffoldQuickSearch(),
    HomePageScaffoldAdvancedSearch(),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    debugPrint("Debugging Home Page");

    _tabController = TabController(
      length: myTabs.length,
      initialIndex: 0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //from:
  //    - ./res/layout/main.xml
  //    - ./src/com/searchmavenapp/android/maven/search/activities/Main.java
  //    - ./res/layout/main_advanced_search.xml
  //    - ./src/com/searchmavenapp/android/maven/search/activities/MainAdvancedSearch.java

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomePageNavigationDrawer(
        tabController: _tabController,
      ),
      appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          )),
      body: TabBarView(
        controller: _tabController,
        children: myTabPages,
      ),
    );
  }
}
