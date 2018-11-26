import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/jsonplaceholder.dart';


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
