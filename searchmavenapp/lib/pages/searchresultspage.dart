import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/centralsearchapi.dart';

class SearchResultsPage extends StatelessWidget {
  final SearchTerms searchTerms;

  final bool iDemoMode = true;
  
  final String _quickSearchKey = "q="; //TODO: move to the API class
  final int _start = 0; //TODO: figure out where this should go

  SearchResultsPage({Key key, @required this.searchTerms}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    debugPrint("search: ${searchTerms.searchType}");
    String quickSearch = "$_quickSearchKey${searchTerms.quickSearch}"; //TODO: move to the API class?? && implement advanced search

    if(searchTerms.isQuickSearch() == false){
      return Scaffold(
        appBar: AppBar(title: Text("${searchTerms.searchType} Search Results")),
        body: Text("Only quick search allowed"));
    }
    
    return Scaffold(
      appBar: AppBar(title: Text("${searchTerms.searchType} Search Results")),
      body: FutureBuilder<MavenCentralResponse>(
        //TODO: call the API outside of build - init state? - https://flutter.io/docs/cookbook/networking/fetch-data#5-moving-the-fetch-call-out-of-the-build-method
        future: CentralSearchAPI().search(pSearchQueryString: quickSearch, pStart: _start, pDemoMode: iDemoMode), 
        builder: (context, AsyncSnapshot<MavenCentralResponse> snapshot) {
          if (snapshot.hasData) {
            return MavenCentralResponseList(response: snapshot.data);
          } else if (snapshot.hasError) {
            return Text("Search Failed: ${snapshot.error}"); //TODO: report back
          }

          // By default, show a loading spinner
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Searching search.maven.org", style: Theme.of(context).textTheme.title,),
              ],
            )
          );
        }
      )
    );
  }
}

//https://flutter.io/docs/cookbook/navigation/passing-data
//passing with plain old Strings didn't work
class SearchTerms {
  final String searchType; //"Quick" or "Advanced" - TODO: classname, group, artifact, all versions

  final String quickSearch;
  
  final String groupId;
  final String artifactId;
  final String version;
  final String packaging;
  final String classifier;

  final String classname;

  SearchTerms({@required this.searchType,
    this.quickSearch,
    this.groupId,
    this.artifactId,
    this.version,
    this.packaging,
    this.classifier,
    this.classname,
  });

  bool isQuickSearch(){
    return "Quick" == searchType;
  }

  @override
    String toString() {
      if (isQuickSearch()) {
        return "$searchType Search Terms - $quickSearch";
      }
      else if ("Advanced" == searchType) {
        return "$searchType Search Terms - $groupId:$artifactId:$version:$packaging:$classifier";
      }
      else if ("Classname" == searchType){
        return "$searchType Search Terms - $classname";
      }
      else {
        return  "Other Search: $searchType";
      }
    }
}


class MavenCentralResponseList extends StatelessWidget {
  final MavenCentralResponse response;

  MavenCentralResponseList({Key key, this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      padding: EdgeInsets.all(16.0),
      // ield identifies the size of the items based on an aspect ratio (width over height).
      childAspectRatio: 8.0 / 10.0,
      children: _buildGridCards2(context, response.response.docs),
    );
  }

  List<Widget> _buildGridCards2(BuildContext context, List<MCRDoc> pArtifacts){
    return pArtifacts.map( (artifact) {
      return _createArtifactCard(context, artifact);
    }).toList();
  }

  Widget _createArtifactCard(BuildContext context, MCRDoc pArtifact){
    //TODO: put back gesture detector and tap listeners
    //TODO: more styling and data
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'GroupId: ' + pArtifact.iG,
                  style: Theme.of(context).textTheme.headline,
                  maxLines: 3,
                ),
                SizedBox(height: 8.0),
                Text(
                  'ArtifactId: ' + pArtifact.iA,
                  style: Theme.of(context).textTheme.subhead.copyWith(fontStyle: FontStyle.italic, color: Colors.red),
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
}