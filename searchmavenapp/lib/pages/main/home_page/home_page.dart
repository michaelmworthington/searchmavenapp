import 'package:flutter/material.dart';
import 'package:searchmavenapp/pages/main/home_page/home_page_floating_action_button.dart';

import '../search_results_page/search_results_page.dart';
import 'home_page_navigation_drawer.dart';
import 'home_page_scaffold_advanced_search.dart';
import 'home_page_scaffold_quick_search.dart';
import '../../../page_components/search_terms.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/';

  const MyHomePage({Key? key, required this.title, required this.isDemoMode})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final bool isDemoMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//This class defines a build() method
//which defines the layout for the Home Page
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //Learn Flutter With Me - https://www.youtube.com/watch?v=1vHf5kQ0E2I - Form Fields and Form Validation
  final _formStateKeyQuickSearch = GlobalKey<FormState>();
  final _formStateKeyAdvancedSearch = GlobalKey<FormState>();

  //TODO: can move to child widgets???
  //https://flutter.io/docs/cookbook/forms/retrieve-input
  final _quickSearchTextController = TextEditingController();
  final _groupIdTextController = TextEditingController();
  final _artifactIdTextController = TextEditingController();
  final _versionTextController = TextEditingController();
  final _packagingTextController = TextEditingController();
  final _classifierTextController = TextEditingController();
  final _classnameTextController = TextEditingController();

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
      HomePageScaffoldQuickSearch(
        formStateKey: _formStateKeyQuickSearch,
        quickSearchTextController: _quickSearchTextController,
        submitSearch: _submitQuickSearch,
      ),
      HomePageScaffoldAdvancedSearch(
        formStateKey: _formStateKeyAdvancedSearch,
        groupIdSearchTextController: _groupIdTextController,
        artifactIdSearchTextController: _artifactIdTextController,
        versionSearchTextController: _versionTextController,
        packagingSearchTextController: _packagingTextController,
        classifierSearchTextController: _classifierTextController,
        classnameSearchTextController: _classnameTextController,
        submitSearch: _submitAdvancedSearch,
      ),
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
    _quickSearchTextController.dispose();
    _groupIdTextController.dispose();
    _artifactIdTextController.dispose();
    _versionTextController.dispose();
    _packagingTextController.dispose();
    _classifierTextController.dispose();
    _classnameTextController.dispose();
    super.dispose();
  }

  void _clearAllSearchTextFields() {
    _quickSearchTextController.clear();
    _groupIdTextController.clear();
    _artifactIdTextController.clear();
    _versionTextController.clear();
    _packagingTextController.clear();
    _classifierTextController.clear();
    _classnameTextController.clear();
  }

  //from:
  //    - android submit action - ./src/com/searchmavenapp/android/maven/search/KeyboardSearchEditorActionListener.java
  //    - ./src/com/searchmavenapp/android/maven/search/constants/TextViewHelper.java
  void _submitQuickSearch() {
    if (_formStateKeyQuickSearch.currentState!.validate()) {
      _formStateKeyQuickSearch.currentState!.save();

      debugPrint("Submitting Quick search");

      var searchTerms = SearchTerms(
        searchType: 'Quick',
        quickSearch: _quickSearchTextController.text,
      );

      Navigator.pushNamed(
        context,
        SearchResultsPage.routeName,
        arguments: <String, SearchTerms>{
          'searchTerms': searchTerms,
        },
      );

      _clearAllSearchTextFields();
    }
  }

  void _submitAdvancedSearch() {
    if (_formStateKeyAdvancedSearch.currentState!.validate()) {
      _formStateKeyAdvancedSearch.currentState!.save();

      debugPrint("Submitting Advanced search");

      var searchTerms = SearchTerms(
        searchType: 'Advanced',
        groupId: _groupIdTextController.text,
        artifactId: _artifactIdTextController.text,
        version: _versionTextController.text,
        packaging: _packagingTextController.text,
        classifier: _classifierTextController.text,
        classname: _classnameTextController.text,
      );

      Navigator.pushNamed(
        context,
        SearchResultsPage.routeName,
        arguments: <String, SearchTerms>{
          'searchTerms': searchTerms,
        },
      );

      _clearAllSearchTextFields();
    }
  }

  void _submitFABSearch() {
    if (_tabController.index == 0) {
      _submitQuickSearch();
    } else {
      _submitAdvancedSearch();
    }
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
        isDemoMode: widget.isDemoMode,
      ),
      floatingActionButton: HomePageFloatingActionButton(
        submitSearch: _submitFABSearch,
      ),
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _myTabPages,
      ),
    );
  }
}
