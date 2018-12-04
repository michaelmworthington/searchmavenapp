import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/centralsearchapi.dart';
import 'package:searchmavenapp/pages/fourthpage.dart';
import 'package:searchmavenapp/pages/secondpage.dart';
import 'package:searchmavenapp/pages/thirdpage.dart';

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
      childAspectRatio: 16.0 / 6.0, //deal with overflow
      children: _buildGridCards2(context, response.response.docs),
    );
  }

  List<Widget> _buildGridCards2(BuildContext context, List<MCRDoc> pArtifacts){
    return pArtifacts.map( (artifact) {
      return _createArtifactCard(context, artifact);
    }).toList();
  }

  Widget _createArtifactCard(BuildContext context, MCRDoc pArtifact){
    //TODO: more styling and deal with childAspectRatio overflow
    return GestureDetector(
      onTap:() =>
        showDialog(context: context,
          builder: (context) => _dialogBuilderTap(context, pArtifact)),
      onLongPress:() =>
        showDialog(context: context,
          builder: (context) => _dialogBuilderLongPress(context, pArtifact)),
      child: Card(
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
                  Text(
                    'Latest Version: ' + pArtifact.iLatestVersion,
                    style: Theme.of(context).textTheme.body1,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Latest Release: ' + DateTime.fromMillisecondsSinceEpoch(pArtifact.iTimestamp).toString(),
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _dialogBuilderTap(BuildContext pContext, MCRDoc pPhoto){
    return SimpleDialog(
      contentPadding: EdgeInsets.all(16),
      children: <Widget>[
        Text("MCRDoc Tapped: " + pPhoto.iA, style: Theme.of(pContext).textTheme.title), //TODO: show artifact details
        SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(pContext);
                },
                child: Text("Close")
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(pContext);
                },
                child: Text("OK")
              )
            ]
          )
        )
      ]
    );
  }

  Widget _dialogBuilderLongPress(BuildContext pContext, MCRDoc pArtifact){
    //https://docs.flutter.io/flutter/material/SimpleDialog-class.html
    return SimpleDialog(
      title: Text("Search By:"), //TODO: Styling
      children: <Widget>[
        SimpleDialogOption(
          child: Text("Group Id"), //TODO: make bigger and add padding
          onPressed: () {
            Navigator.pop(pContext);
            //TODO: Group Id Search
            Navigator.push(pContext,
                MaterialPageRoute(builder: (context) => SecondPage(pCounter: 3, pSearchTerm: "menu"))
            );
          },
        ),
        SimpleDialogOption(
          child: Text("Artifact Id"),
          onPressed: () {
            //Close the drawer
            Navigator.pop(pContext);
            //TODO: artifact id search
            Navigator.push(pContext,
                MaterialPageRoute(builder: (context) => ThirdPage())
            );
          },
        ),
        SimpleDialogOption(
          child: Text("All " + pArtifact.iVersionCount.toString() + " Versions"),
          onPressed: () {
            //Close the drawer
            Navigator.pop(pContext);
            //TODO: All Versions search
            Navigator.push(pContext,
                MaterialPageRoute(builder: (context) => FourthPage())
            );
          },
        )
      ]
    ); 
  }
}