import 'package:flutter/foundation.dart';
//import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'jsonplaceholder_photo.dart';
import 'jsonplaceholder_post.dart';

//For the Isolates / Compute part to work in fetchPhotos(),
//this function needs to be a top level function
//https://github.com/flutter/flutter/issues/16983
//
// A function that will convert a response body into a List<Photo>
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class GetJsonPlaceholderData {
  Future<List<Photo>> fetchPhotos(http.Client client) async {
    Uri myUri = Uri(
      scheme: 'https',
      host: 'jsonplaceholder.typicode.com',
      path: '/photos/',
    );

    final response = await client.get(myUri);

    // Use the compute function to run parsePhotos in a separate isolate
    return compute(parsePhotos, response.body);
  }

  Future<Post> fetchPost() async {
    Uri myUri = Uri(
      scheme: 'https',
      host: 'jsonplaceholder.typicode.com',
      path: '/posts/1',
    );

    final response = await http.get(myUri);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return Post.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
