import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    as font_awesome_flutter;
import 'package:flutter/foundation.dart';
//import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:http/http.dart' as http;
import 'colors.dart';

void main() => runApp(MyApp());

ThemeData _buildTheme() {
  return ThemeData(
    primarySwatch: Colors.blueGrey,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder()
    )
  );
}

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
                          child: Text("CLEAR"),
                          textColor: Theme.of(context).primaryColor
                        ),
                        RaisedButton(
                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => SecondPage(pCounter: _counter)));
                            }, 
                            child: Icon(Icons.search, color:Theme.of(context).primaryColorLight),
                            color: Theme.of(context).primaryColor,
                        )
                    ],
                  )
                ]
              )
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text("Quick Search")),
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
}

class SecondPage extends StatelessWidget {
  SecondPage({int pCounter}){
    print("counter was $pCounter");
    _counter = pCounter;
  }

  static int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("second screen")),
        body: Center(child: 
                Column(children: <Widget>[
                  Expanded(child:
                    ListView.builder(
                      itemCount: _counter,
                      itemBuilder: (context, index) {
                        return ListTile(
                            leading: const Icon(Icons.account_circle),
                            title: Text("Name of item: $index"),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => SearchResultsPage()));
                            });
                      },
                    )
                  ),
                  Divider(color: Colors.red),

                  RaisedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text("Go Back"),
                    icon: new Icon(font_awesome_flutter.FontAwesomeIcons.stepBackward)
                  )
                ])
        )
    );
  }
}

class SearchResultsPage extends StatelessWidget {
  static final String _searchTerm = "log4j"; //TODO
  static final String _quickSearch = "q=$_searchTerm";
  static final int _start = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Results")),
      body: FutureBuilder<MavenCentralResponse>(
        future: CentralSearchAPI().search(pSearchQueryString: _quickSearch, pStart: _start),
        builder: (context, AsyncSnapshot<MavenCentralResponse> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.response.numFound.toString());
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        }
      )
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("third screen")),
      body: FutureBuilder<Post>(
        future: GetData().fetchPost(),
        builder: (context, AsyncSnapshot<Post> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.title);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        }
      )
    );
  }
}

class FourthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("fourth screen")),
      body: FutureBuilder<List<Photo>>(
        future: GetData().fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        }
      )
    );
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

//For the Isolates / Compute part to work in fetchPhotos(), 
//this function needs to be a top level function
//https://github.com/flutter/flutter/issues/16983
//
// A function that will convert a response body into a List<Photo>
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class GetData {

  Future<List<Photo>> fetchPhotos(http.Client client) async {
    final response =
        await client.get('https://jsonplaceholder.typicode.com/photos');

    // Use the compute function to run parsePhotos in a separate isolate
    return compute(parsePhotos, response.body);
  }

  Future<Post> fetchPost() async {
    final response =
        await http.get("http://jsonplaceholder.typicode.com/posts/1");

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return Post.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;

  Photo({this.id, this.title, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  Card _createPhotoCard(BuildContext context, Photo pPhoto){
    final ThemeData theme = Theme.of(context);

    return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18.0 / 11.0,
                child: Image.network(
                  pPhoto.thumbnailUrl, 
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Title: ' + pPhoto.title,
                      style: theme.textTheme.title,
                      maxLines: 3,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Id: ' + pPhoto.id.toString(),
                      style: theme.textTheme.body2,
                    ),
                    SizedBox(height: 8.0),
                    Text('Third Text'),
                    SizedBox(height: 8.0),
                    Text('Fourth Text'),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  List<Card> _buildGridCards2(BuildContext context, List<Photo> pPhotos){
    return pPhotos.map( (photo) {
      return _createPhotoCard(context, photo);
    }).toList();
  }
    
  @override
  Widget build(BuildContext context) {
    

    return GridView.count(
      crossAxisCount: 1,
      padding: EdgeInsets.all(16.0),
      // ield identifies the size of the items based on an aspect ratio (width over height).
      childAspectRatio: 8.0 / 10.0,
      children: _buildGridCards2(context, photos),
    );
  }
}

class CentralSearchAPI {

  //See MavenCentralRestAPI.java
  Future<MavenCentralResponse> search({String pSearchQueryString, int pStart}) async {
    int _numResults = 20;

    String baseUrl = "http://search.maven.org/solrsearch/select?";
    String numResults = "rows=" + _numResults.toString();
    String startPosition = "start=" + pStart.toString();
    String resultsFormat = "wt=json";

    String url = baseUrl + numResults + "&" + startPosition + "&" + resultsFormat + "&" + pSearchQueryString;


    print("Searching Central: $url");
    
    final response =
        await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      print(response.body);

      //Supplemental parsing json w/ dart: https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
      return MavenCentralResponse.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load MavenCentralResponse');
    }
  }
}

class MavenCentralResponse {
  final Map responseHeader;
  final MCRResponse response;
  final Map spellcheck;

  MavenCentralResponse({this.responseHeader, this.response, this.spellcheck});

  factory MavenCentralResponse.fromJson(Map<String, dynamic> json) {
    return MavenCentralResponse(
      responseHeader: json['responseHeader'],
      response: MCRResponse.fromJson(json['response']),
      spellcheck: json['spellcheck'],
    );
  }
}

class MCRResponse {
  final int numFound;
  final int start;
  final List docs;

  MCRResponse({this.numFound, this.start, this.docs});

  factory MCRResponse.fromJson(Map<String, dynamic> json) {
    return MCRResponse(
      numFound: json['numFound'],
      start: json['start'],
      docs: json['docs'],
    );
  }

}