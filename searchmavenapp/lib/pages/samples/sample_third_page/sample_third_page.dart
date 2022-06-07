import 'package:flutter/material.dart';

import '../../../api/jsonplaceholder/jsonplaceholder.dart';
import '../../../api/jsonplaceholder/model/jsonplaceholder_post.dart';

class SampleThirdPage extends StatelessWidget {
  const SampleThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("third screen"),
      ),
      body: FutureBuilder<Post>(
        future: GetJsonPlaceholderData().fetchPost(),
        builder: (context, AsyncSnapshot<Post> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data?.title ?? '');
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
