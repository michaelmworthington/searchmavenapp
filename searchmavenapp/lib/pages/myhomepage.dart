import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:searchmavenapp/pages/searchresultspage.dart';
import 'package:searchmavenapp/pages/secondpage.dart';
import 'package:searchmavenapp/pages/thirdpage.dart';
import 'package:searchmavenapp/pages/fourthpage.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.storage}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//This class defines a build() method
//which defines the layout for the Home Page
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  //https://flutter.io/docs/cookbook/forms/retrieve-input
  final _searchTextController = TextEditingController();
  final _groupIdTextController = TextEditingController();
  final _artifactIdTextController = TextEditingController();
  final _versionTextController = TextEditingController();
  final _packagingTextController = TextEditingController();
  final _classifierTextController = TextEditingController();
  final _classnameTextController = TextEditingController();

  //https://stackoverflow.com/questions/52150677/how-to-shift-focus-to-next-textfield-in-flutter
  final _artifactIdFocusNode = FocusNode();

  
  //https://flutter.io/docs/cookbook/design/tabs
  //https://stackoverflow.com/questions/50123354/how-to-get-current-tab-index-in-flutter
  TabController _tabController;

  //lynda.com
  int _counter;

  @override
  void initState() {
    super.initState();
    debugPrint("Debugging Home Page");

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchTextController.dispose();
    _groupIdTextController.dispose();
    _artifactIdTextController.dispose();
    _versionTextController.dispose();
    _packagingTextController.dispose();
    _classifierTextController.dispose();
    _classnameTextController.dispose();
    super.dispose();
  }

  Future<File> _incrementCounter() async {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });

    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    //https://flutter.io/docs/cookbook/design/drawer
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: "Quick Search"),
            Tab(text: "Advanced Search"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildQuickSearch(context),
          _buildAdvancedSearch(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView( //TODO: how does it scroll?? maybe use a column
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("Drawer Header"), //TODO: Info or picture
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
          ),
          ListTile(
            title: Text("Quick Search"),
            leading: Icon(Icons.search),
            onTap: () {
              //Close the drawer
              Navigator.pop(context);
              //Go to the page
              _tabController.index = 0;
            },
          ),
          ListTile(
            title: Text("Advanced Search"),
            leading: Icon(Icons.youtube_searched_for),
            onTap: () {
              //Close the drawer
              Navigator.pop(context);
              //Go to the page
              _tabController.index = 1;
            },
          ),
          ListTile(
            title: Text("Help"),
            leading: Icon(Icons.help),
            onTap: () {
              //Close the drawer
              Navigator.pop(context);
              //Go to the page
            },
          ),
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings),
            onTap: () {
              //Close the drawer
              Navigator.pop(context);
              //Go to the page
            },
          ),
          ListTile(
            title: Text("About"),
            leading: Icon(Icons.info),
            onTap: () {
              //Close the drawer
              Navigator.pop(context);
              //Go to the page
            },
          ),
          ListTile(
            title: Text("Second"),
            leading: Icon(Icons.book),
            onTap: () {
              //Close the drawer
              Navigator.pop(context);
              //Go to the page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecondPage(pCounter: _counter, pSearchTerm: "menu"))
              );
            },
          ),
          ListTile(
            title: Text("Third"),
            leading: Icon(Icons.play_arrow),
            onTap: () {
              //Close the drawer
              Navigator.pop(context);
              //Go to the page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ThirdPage())
              );
            },
          ),
          ListTile(
            title: Text("Fourth"),
            leading: Icon(Icons.play_circle_outline),
            onTap: () {
              //Close the drawer
              Navigator.pop(context);
              //Go to the page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FourthPage())
              );
            },
          ),
        ],
      )
    );
  }

  Widget _buildAdvancedSearch(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        Text("By Coordinate", style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColor)),
        SizedBox(height: 12.0),
        TextField(
          controller: _groupIdTextController,
          decoration: InputDecoration(labelText: 'GroupId'),
          onSubmitted: (value) {FocusScope.of(context).requestFocus(_artifactIdFocusNode);}, //TODO: do the rest
          autofocus: true,
        ),
        SizedBox(height: 12.0),
        TextField(
          controller: _artifactIdTextController,
          decoration: InputDecoration(labelText: 'ArtifactId'),
          focusNode: _artifactIdFocusNode,
        ),
        SizedBox(height: 12.0),
        TextField(
          controller: _versionTextController,
          decoration: InputDecoration(labelText: 'Version'),
        ),
        SizedBox(height: 12.0),
        TextField(
          controller: _packagingTextController,
          decoration: InputDecoration(labelText: 'Packaging'),
        ),
        SizedBox(height: 12.0),
        TextField(
          controller: _classifierTextController,
          decoration: InputDecoration(labelText: 'Classifier'),
        ),
        SizedBox(height: 12.0),
        Text("By Classname", style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColor)),
        SizedBox(height: 12.0),
        TextField(
          controller: _classnameTextController,
          decoration: InputDecoration(labelText: 'Classname')
        ),
        //don't need the spacer when using the button bar
        //SizedBox(height: 12.0),

        ButtonBar(alignment: MainAxisAlignment.center,
          children: <Widget>[
              FlatButton(onPressed: (){
                  _groupIdTextController.clear();
                  _artifactIdTextController.clear();
                  _versionTextController.clear();
                  _packagingTextController.clear();
                  _classifierTextController.clear();
                  _classnameTextController.clear();
                },
                child: Text("CLEAR")
              ),
              RaisedButton(
                  onPressed: (){
                    SearchTerms searchTerms = SearchTerms(searchType: "Advanced", 
                    groupId: _groupIdTextController.text,
                    artifactId: _artifactIdTextController.text,
                    version: _versionTextController.text,
                    packaging: _packagingTextController.text,
                    classifier: _classifierTextController.text,
                    classname: _classnameTextController.text,
                    );

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchResultsPage(searchTerms: searchTerms)));
                  }, 
                  child: Icon(Icons.search)
              )
          ],
        ),
      ],
    );
  }

  Widget _buildQuickSearch(BuildContext context) {
    return Center(child:
      Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _searchTextController,
              decoration: InputDecoration(
                //filled: true,
                labelText: 'Quick Search'
              ),
              onSubmitted: (value){_submitSearchTerms(pSearchType: "Quick");},
            )
          ),
          //don't need the spacer when using the button bar
          //SizedBox(height: 12.0),

          ButtonBar(alignment: MainAxisAlignment.center,
            children: <Widget>[
                FlatButton(onPressed: (){
                    _searchTextController.clear();
                  },
                  child: Text("CLEAR")
                ),
                RaisedButton(
                    onPressed: (){_submitSearchTerms(pSearchType: "Quick");}, 
                    child: Icon(Icons.search)
                )
            ],
          )
        ]
      )
    );
  }

  void _submitSearchTerms({@required String pSearchType}) {
    SearchTerms searchTerms = SearchTerms(searchType: pSearchType, quickSearch: _searchTextController.text);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchResultsPage(searchTerms: searchTerms)));
    _searchTextController.clear();
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      //if no data in the file, return 0 for the counter
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}
