import 'package:flutter/material.dart';

import 'pages/home_page/home_page_navigation_drawer.dart';
import 'pages/home_page/home_page_scaffold_advanced_search.dart';
import 'pages/home_page/home_page_scaffold_quick_search.dart';
import 'pages/sample_fourth_page/sample_fourth_page.dart';
import 'pages/sample_second_page/sample_second_page.dart';
import 'pages/sample_third_page/sample_third_page.dart';
import 'pages/settings_page/settings_page.dart';

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
      // don't define home when using a named route with '/'
      // home: const MyHomePage(title: 'Search Maven App'),
      initialRoute: '/',
      // mmw: i'm using these for pages that don't require any arguments, or use
      //      ModalRoute.of(context)!.settings.arguments to extract the arguments
      routes: {
        '/': (context) => const MyHomePage(title: 'Search Maven App'),
        '/settings': (context) => const SettingsPage(),
        '/sample_third': (context) => const SampleThirdPage(),
        '/sample_fourth': (context) => const SampleFourthPage(),
      },
      // mmw: these pages require arguments on the Widget constructor
      //      https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/sample_second') {
          final args = settings.arguments as Map<String, String>;

          return MaterialPageRoute(
            builder: (context) {
              return SampleSecondPage(
                searchTerm: args['searchTerm'] ?? '',
                counter: int.parse(args['counter'] ?? '100'),
              );
            },
          );
        }

        // The code only supports
        // PassArgumentsScreen.routeName right now.
        // Other values need to be implemented if we
        // add them. The assertion here will help remind
        // us of that higher up in the call stack, since
        // this assertion would otherwise fire somewhere
        // in the framework.
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
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
  // https://flutter.io/docs/cookbook/design/tabs
  // https://stackoverflow.com/questions/50123354/how-to-get-current-tab-index-in-flutter
  // Johannes Milke - https://www.youtube.com/watch?v=8x2Ssf5OxQ4
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
        myAppTitle: widget.title,
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
