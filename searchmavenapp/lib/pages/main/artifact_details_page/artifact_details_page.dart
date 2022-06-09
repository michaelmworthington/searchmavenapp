import 'package:flutter/material.dart';
import 'package:searchmavenapp/pages/main/artifact_details_page/artifact_details_app_bar_menu_items.dart';

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../../page_components/artifact_field_text_ellipsis.dart';
import '../../../page_components/form_header.dart';
import '../pom_view_page/pom_view_page.dart';
import 'artifact_details_app_bar_menu_item_model.dart';

class ArtifactDetailsPage extends StatelessWidget {
  final MCRDoc iArtifact;

  const ArtifactDetailsPage({Key? key, required this.iArtifact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Artifact Details"),
          actions: [
            PopupMenuButton<ArtifactDetailsAppBarMenuItemModel>(
              position: PopupMenuPosition.under,
              icon: const Icon(Icons.more_vert),
              onSelected: (item) => item.onSelected(context),
              itemBuilder: (context) => [
                ...ArtifactDetailsAppBarMenuItems.items
                    .map((item) => item.buildPopupMenuItem(iArtifact))
                    .toList(),
              ],
            ),
          ],
        ),
        body: _buildArtifactDetails(context));
  }

  Widget _buildArtifactDetails(BuildContext context) {
    //from:
    //    - ./res/layout/artifact_details.xml
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        const MyFormHeader(
          pLabel: 'Project Information:',
        ),
        const SizedBox(height: 12.0),
        ArtifactFieldTextEllipsis(
          label: 'Group Id',
          value: '${iArtifact.iG}',
        ),
        const SizedBox(height: 12.0),
        ArtifactFieldTextEllipsis(
          label: 'Artifact Id',
          value: '${iArtifact.iA}',
          // maxLines: 2,
        ),
        const SizedBox(height: 12.0),
        ArtifactFieldTextEllipsis(
          label: 'Version',
          value: '${iArtifact.iLatestVersion}',
        ),
        const SizedBox(height: 12.0),
        const MyFormHeader(
          pLabel: 'Artifact Files:',
        ),
        const SizedBox(height: 12.0),
        //TODO: show the files
        const Text("pom"),
        const Text("jar"),
        const Text("sha1"),
        const Text("md5"),
        const SizedBox(height: 12.0),
        const MyFormHeader(
          pLabel: 'Dependency Information:',
        ),
        const SizedBox(height: 12.0),
        //TODO: show the XML - Drop down modal for other formats
        Text("Maven Dependency XML: ${iArtifact.iRepositoryId}"),
        const SizedBox(height: 12.0),
        const MyFormHeader(
          pLabel: 'Project Object Model (POM):',
        ),
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
