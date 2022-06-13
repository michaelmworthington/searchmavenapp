import 'dart:convert';

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:highlight/languages/xml.dart';
import 'package:flutter_highlight/themes/darcula.dart';

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../../page_components/artifact_field_text_ellipsis.dart';
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
        const MyFormHeader(pLabel: 'Project Information:'),
        const SizedBox(height: 12.0),
        ..._buildProjectInformationWidgets(),
        const SizedBox(height: 12.0),
        const MyFormHeader(pLabel: 'Artifact Files:'),
        const SizedBox(height: 12.0),
        ..._buildArtifactFilesWidgets(),
        const SizedBox(height: 12.0),
        const MyFormHeader(pLabel: 'Dependency Information:'),
        const SizedBox(height: 12.0),
        ..._buildDependencyInformationWidgets(),
        const SizedBox(height: 12.0),
        const MyFormHeader(pLabel: 'Project Object Model (POM):'),
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

enum DependencyChoices {
  maven(value: "Apache Maven"),
  groovy(value: "Gradle Groovy DSL"),
  kotlin(value: "Gradle Kotlin DSL"),
  scala(value: "Scala SBT"),
  ivy(value: "Apache Ivy"),
  grape(value: "Groovy Grape"),
  lein(value: "Leiningen"),
  buildr(value: "Apache Buildr"),
  central(value: "Maven Central Badge"),
  purl(value: "PURL"),
  bazel(value: "Bazel");

  const DependencyChoices({
    required this.value,
  });

  final String value;

  CodeController createCodeController(MCRDoc artifact) => CodeController(
        text: _generateDependencyText(artifact),
        language: _getLanguage(),
        theme: darculaTheme,
      );

  Mode? _getLanguage() {
    switch (this) {
      case DependencyChoices.maven:
        return xml;
      case DependencyChoices.central:
        return markdown;
      case DependencyChoices.purl:
        return null;
      default:
        return null;
    }
  }

  String _generateDependencyText(MCRDoc artifact) {
    String? groupId = artifact.iG;
    String? artifactId = artifact.iA;
    String? version = artifact.iV ??
        artifact.iLatestVersion; //TODO: selected version vs latest

    switch (this) {
      case DependencyChoices.maven:
        return '''
<dependency>
  <groupId>$groupId</groupId>
  <artifactId>$artifactId</artifactId>
  <version>$version</version>
</dependency>
''';
      case DependencyChoices.central:
        //TODO: version? - https://shields.io/category/version
        return '''
[![Maven Central](https://img.shields.io/maven-central/v/$groupId/$artifactId.svg?label=Maven%20Central)](https://search.maven.org/search?q=g:%22$groupId%22%20AND%20a:%22$artifactId%22)
''';
      case DependencyChoices.purl:
        return '''
pkg:maven/$groupId/$artifactId@$version
''';
      default:
        return '';
    }
  }
}
