import 'package:flutter/material.dart';

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../../page_components/form_header.dart';
import '../pom_view_page/pom_view_page.dart';

class ArtifactDetailsPage extends StatelessWidget {
  final MCRDoc iArtifact;

  const ArtifactDetailsPage({Key? key, required this.iArtifact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Artifact Details")),
        body: _buildArtifactDetails(context));
  }

  Widget _buildArtifactDetails(BuildContext context) {
    //from:
    //    - ./res/layout/artifact_details.xml
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        MyFormHeader(context: context, pLabel: 'Project Information:'),
        const SizedBox(height: 12.0),
        //TODO: Styling
        Text("GroupId: ${iArtifact.iG}"),
        const SizedBox(height: 12.0),
        Text("ArtifactId: ${iArtifact.iA}"),
        const SizedBox(height: 12.0),
        Text("Version: ${iArtifact.iLatestVersion}"),
        const SizedBox(height: 12.0),
        MyFormHeader(context: context, pLabel: 'Artifact Files:'),
        const SizedBox(height: 12.0),
        //TODO: show the files
        const Text("pom"),
        const Text("jar"),
        const Text("sha1"),
        const Text("md5"),
        const SizedBox(height: 12.0),
        MyFormHeader(context: context, pLabel: 'Dependency Information:'),
        const SizedBox(height: 12.0),
        //TODO: show the XML
        Text("Maven Dependency XML: ${iArtifact.iRepositoryId}"),
        const SizedBox(height: 12.0),
        MyFormHeader(context: context, pLabel: 'Project Object Model (POM):'),
        //don't need the spacer when using the button bar
        //SizedBox(height: 12.0),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PomViewPage(iArtifact: iArtifact)));
                },
                child: const Text("Show POM"))
          ],
        ),
      ],
    );
  }
}
