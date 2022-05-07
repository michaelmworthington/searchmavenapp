import 'package:flutter/material.dart';

import 'home_page_navigation_drawer.dart';
import 'home_page_scaffold_advanced_search.dart';
import 'home_page_scaffold_quick_search.dart';

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
  //Learn Flutter With Me - https://www.youtube.com/watch?v=1vHf5kQ0E2I
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  // https://flutter.io/docs/cookbook/design/tabs
  // https://stackoverflow.com/questions/50123354/how-to-get-current-tab-index-in-flutter
  // Johannes Milke - https://www.youtube.com/watch?v=8x2Ssf5OxQ4
  static const List<Tab> myTabs = <Tab>[
    Tab(text: "Quick Search"),
    Tab(text: "Advanced Search"),
  ];

  late List<Widget> _myTabPages;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    debugPrint("Debugging Home Page");

    _myTabPages = <Widget>[
      HomePageScaffoldQuickSearch(formStateKey: _formStateKey),
      const HomePageScaffoldAdvancedSearch(),
    ];

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formStateKey.currentState!.validate()) {
            _formStateKey.currentState!.save();
          }
          debugPrint("Search Submitted");

          Navigator.pushNamed(
            context,
            '/search_results',
            arguments: <String, String>{
              'searchTerm': 'menu',
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/icon/icon_search_transparent.png',
            fit: BoxFit.fill,
          ),
        ),
        // child: const Icon(Icons.search),
      ),
      appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          )),
      body: TabBarView(
        controller: _tabController,
        children: _myTabPages,
      ),
    );
  }
}
