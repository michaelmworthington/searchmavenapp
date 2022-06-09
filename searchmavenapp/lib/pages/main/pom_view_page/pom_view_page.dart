import 'package:flutter/material.dart';

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../../page_components/form_header.dart';

class PomViewPage extends StatelessWidget {
  final MCRDoc iArtifact;

  const PomViewPage({Key? key, required this.iArtifact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Artifact Details - POM")),
        body: _buildPomView(context));
  }

  Widget _buildPomView(BuildContext context) {
    //from:
    //    - ./res/layout/pom_view.xml
    //    - ./src/com/searchmavenapp/android/maven/search/activities/PomViewActivity.java
    //            - from progress thread, the content is downloaded from MavenCentralRestAPI.java
    //              going to s.m.o/remotecontent?filepath=$filename
    //            - see MavenCentralRestAPI.downloadFile()
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        const MyFormHeader(pLabel: 'pom.xml:'),
        const SizedBox(height: 12.0),
        //TODO: Styling & content
        Text("<pom> ${iArtifact.iG}"),
      ],
    );
  }
}
