import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/centralsearchapi.dart';


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
