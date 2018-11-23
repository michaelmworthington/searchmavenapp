import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
//import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


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