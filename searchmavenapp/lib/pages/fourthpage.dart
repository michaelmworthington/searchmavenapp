import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:searchmavenapp/api/centralsearchapi.dart';

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
