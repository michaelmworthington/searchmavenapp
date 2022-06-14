import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../../page_components/artifact_field_text_ellipsis.dart';
import '../../../page_components/dependency_choices.dart';
import '../../../page_components/form_header.dart';
import '../pom_view_page/pom_view_page.dart';
import 'artifact_details_app_bar_menu_item_model.dart';
import 'artifact_details_app_bar_menu_items.dart';

class ArtifactDetailsPage extends StatefulWidget {
  final MCRDoc iArtifact;

  const ArtifactDetailsPage({Key? key, required this.iArtifact})
      : super(key: key);

  @override
  State<ArtifactDetailsPage> createState() => _ArtifactDetailsPageState();
}

class _ArtifactDetailsPageState extends State<ArtifactDetailsPage> {
  DependencyChoices dependencyChoiceValue = DependencyChoices.maven;

  late CodeController codeController;

  @override
  void initState() {
    super.initState();

    codeController =
        dependencyChoiceValue.createCodeController(widget.iArtifact);
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Artifact Details"),
          actions: _buildAppBarActionsMenu(),
        ),
        body: _buildArtifactDetails(context));
  }

  ////////////////////////////////////////////////////////////////////////////////////////////
  //               Helper Methods
  ////////////////////////////////////////////////////////////////////////////////////////////

  List<Widget> _buildAppBarActionsMenu() => [
        PopupMenuButton<ArtifactDetailsAppBarMenuItemModel>(
          position: PopupMenuPosition.under,
          icon: const Icon(Icons.more_vert),
          onSelected: (item) => item.onSelected(context),
          itemBuilder: (context) => [
            ...ArtifactDetailsAppBarMenuItems.items
                .map((item) => item.buildPopupMenuItem(widget.iArtifact))
                .toList(),
          ],
        ),
      ];

  Widget _buildArtifactDetails(BuildContext context) {
    //from:
    //    - ./res/layout/artifact_details.xml
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        MyFormHeader(pLabel: 'Project Information:'),
        const SizedBox(height: 12.0),
        ..._buildProjectInformationWidgets(),
        const SizedBox(height: 12.0),
        // MyFormHeader(pLabel: 'Artifact Files:'),
        // const SizedBox(height: 12.0),
        // TODO: Figure out how to get the list from the API - and what to do with it?
        // ..._buildArtifactFilesWidgets(),
        // const SizedBox(height: 12.0),
        MyFormHeader(pLabel: 'Dependency Information:'),
        const SizedBox(height: 12.0),
        ..._buildDependencyInformationWidgets(),
        const SizedBox(height: 12.0),
        MyFormHeader(pLabel: 'Project Object Model (POM):'),
        //don't need the spacer when using the button bar
        //SizedBox(height: 12.0),
        ..._buildPomWidgets(),
      ],
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////
  //               Body Methods
  ////////////////////////////////////////////////////////////////////////////////////////////

  List<Widget> _buildDependencyInformationWidgets() => [
        DropdownButton(
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyMedium,
          items: DependencyChoices.values
              .map(
                (item) => DropdownMenuItem(
                  child: Text(item.value),
                  value: item,
                ),
              )
              .toList(),
          value: dependencyChoiceValue,
          onChanged: (DependencyChoices? item) {
            debugPrint("Selected: $item");
            setState(
              () {
                dependencyChoiceValue = item ?? DependencyChoices.maven;
                codeController = dependencyChoiceValue
                    .createCodeController(widget.iArtifact);
              },
            );
          },
        ),
        CodeField(
          controller: codeController,
          textStyle: const TextStyle(fontFamily: 'SourceCode'),

          //Hide the line numbers
          lineNumberStyle: const LineNumberStyle(
              width: 0,
              margin: 10,
              textStyle: TextStyle(color: Colors.transparent)),
        )
      ];

  List<Widget> _buildPomWidgets() => [
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  //TODO: named route
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PomViewPage(iArtifact: widget.iArtifact)));
                },
                child: const Text("Show POM"))
          ],
        )
      ];

  List<Widget> _buildArtifactFilesWidgets() => [
        //TODO: show the files
        const Text("pom"),
        const Text("jar"),
        const Text("sha1"),
        const Text("md5"),
      ];

  List<Widget> _buildProjectInformationWidgets() => [
        ArtifactFieldTextEllipsis(
          label: 'Group Id',
          value: '${widget.iArtifact.iG}',
        ),
        const SizedBox(height: 12.0),
        ArtifactFieldTextEllipsis(
          label: 'Artifact Id',
          value: '${widget.iArtifact.iA}',
          // maxLines: 2,
        ),
        const SizedBox(height: 12.0),
        ArtifactFieldTextEllipsis(
          label: 'Version',
          value:
              '${widget.iArtifact.iLatestVersion}', //TODO: or selected version
        )
      ];
}
