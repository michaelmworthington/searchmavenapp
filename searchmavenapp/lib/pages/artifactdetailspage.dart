import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/centralsearchapi.dart';
import 'package:searchmavenapp/pages/pomviewpage.dart';

class ArtifactDetailsPage extends StatelessWidget {
  final MCRDoc iArtifact;
  ArtifactDetailsPage({Key key, @required this.iArtifact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Artifact Details")),
      body: _buildArtifactDetails(context)
    );
  }

  Widget _buildArtifactDetails(BuildContext context) {
    //from:
    //    - ./res/layout/artifact_details.xml
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        Text("Project Information", style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColor)),
        SizedBox(height: 12.0),
        //TODO: Styling
        Text("GroupId: ${iArtifact.iG}"),
        SizedBox(height: 12.0),
        Text("ArtifactId: ${iArtifact.iA}"),
        SizedBox(height: 12.0),
        Text("Version: ${iArtifact.iLatestVersion}"),

        SizedBox(height: 12.0),

        Text("Artifact Files", style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColor)),
        SizedBox(height: 12.0),
        //TODO: show the files
        Text("pom"),
        Text("jar"),
        Text("sha1"),
        Text("md5"),

        SizedBox(height: 12.0),

        Text("Dependency Information", style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColor)),
        SizedBox(height: 12.0),
        //TODO: show the XML
        Text("Maven Dependency XML: ${iArtifact.iRepositoryId}"),

        SizedBox(height: 12.0),

        Text("Project Object Model (POM)", style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColor)),
        //don't need the spacer when using the button bar
        //SizedBox(height: 12.0),
        ButtonBar(alignment: MainAxisAlignment.center,
          children: <Widget>[
              RaisedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PomViewPage(iArtifact: iArtifact)));
                  },
                  child: Text("Show POM")
              )
          ],
        ),
      ],
    );
  }
}
