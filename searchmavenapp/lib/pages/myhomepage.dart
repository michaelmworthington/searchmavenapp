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
class _MyHomePageState extends State<MyHomePage> {
  final _searchTextController = TextEditingController();
  int _navBarSelectedIndex = 0;

  int _counter;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.play_arrow),
              tooltip: 'http request',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ThirdPage()));
              }),
          IconButton(
              icon: Icon(Icons.play_circle_outline),
              tooltip: 'big http request',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FourthPage()));
              })
        ]),
      body: Center(child:
              Column(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: TextField(
                              controller: _searchTextController,
                              decoration: InputDecoration(
                                //filled: true,
                                labelText: 'Quick Search'
                              )
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
                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => SecondPage(pCounter: _counter)));
                            }, 
                            child: Icon(Icons.search)
                        )
                    ],
                  )
                ]
              )
            ),
      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.shifting,
        fixedColor: Colors.blue,
        currentIndex: _navBarSelectedIndex,
        onTap: _navBarTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text("Quick Search"), backgroundColor: Colors.blueGrey),
          BottomNavigationBarItem(icon: Icon(Icons.location_searching), title: Text("Advanced Search")),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Settings"))
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _navBarTapped(int index){
    //print("bottom nav bar tapped with $index");

    //TODO: https://docs.flutter.io/flutter/material/BottomNavigationBar-class.html
    //TODO: nav bar on all pages (scaffolds) ?
    
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SearchResultsPage()));

    setState(() {
          _navBarSelectedIndex = index;
    });
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
