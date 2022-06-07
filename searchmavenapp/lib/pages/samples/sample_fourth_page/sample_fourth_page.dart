import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../api/jsonplaceholder/jsonplaceholder.dart';
import '../../../api/jsonplaceholder/model/jsonplaceholder_photo.dart';
import 'sample_fourth_page_photos_list.dart';

class SampleFourthPage extends StatelessWidget {
  const SampleFourthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("fourth screen"),
      ),
      body: FutureBuilder<List<Photo>>(
        future: GetJsonPlaceholderData().fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data ?? []);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Searching Photos"),
              ],
            ),
          );
        },
      ),
    );
  }
}
