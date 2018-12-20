import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/centralsearchapi.dart';

class PomViewPage extends StatelessWidget {
  final MCRDoc iArtifact;
  PomViewPage({Key key, @required this.iArtifact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Artifact Details")),
      body: _buildPomView(context)
    );
  }

  Widget _buildPomView(BuildContext context) {
    //from:
    //    - ./res/layout/pom_view.xml
    //    - ./src/com/searchmavenapp/android/maven/search/activities/PomViewActivity.java
    //            - from progress thread, the content is downloaded from MavenCentralRestAPI.java
    //              going to s.m.o/remotecontent?filepath=$filename
    //            - see MavenCentralRestAPI.downloadFile()
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        Text("pom.xml", style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColor)),
        SizedBox(height: 12.0),
        //TODO: Styling & content
        Text("<pom> ${iArtifact.iG}"),
      ],
    );
  }
}
