import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/mavencentral/model/mcr_doc.dart';

import '../../../page_components/search_terms.dart';
import '../search_results_page/search_results_page.dart';
import 'artifact_details_app_bar_menu_item_model.dart';

class ArtifactDetailsAppBarMenuItems {
  static List<ArtifactDetailsAppBarMenuItemModel> items = [
    itemGroupId,
    itemArtifactId,
    itemVersions,
  ];

  static final itemGroupId = ArtifactDetailsAppBarMenuItemModel(
    prefix: 'G',
    label: 'Search by Group Id',
    onSelected: (BuildContext context, MCRDoc artifact) {
      //TODO: Pop the right way - see Sample 4 Alert Dialog
      // Navigator.pop(context);
      // Navigator.pop(context);

      var searchTerms = SearchTerms(
        searchType: SearchTerms.searchTypeAdvanced,
        groupId: artifact.iG ?? '',
      );

      Navigator.pushNamed(
        context,
        SearchResultsPage.routeName,
        arguments: <String, SearchTerms>{
          'searchTerms': searchTerms,
        },
      );
    },
  );

  static final itemArtifactId = ArtifactDetailsAppBarMenuItemModel(
    prefix: 'A',
    label: 'Search by Artifact Id',
    onSelected: (BuildContext context, MCRDoc artifact) {
      // Navigator.pop(context);
      // Navigator.pop(context);

      var searchTerms = SearchTerms(
        searchType: SearchTerms.searchTypeAdvanced,
        artifactId: artifact.iA ?? '',
      );

      Navigator.pushNamed(
        context,
        SearchResultsPage.routeName,
        arguments: <String, SearchTerms>{
          'searchTerms': searchTerms,
        },
      );
    },
  );

  static final itemVersions = ArtifactDetailsAppBarMenuItemModel(
    prefix: 'V',
    label: 'Search All Versions',
    onSelected: (BuildContext context, MCRDoc artifact) {
      // Navigator.pop(context);
      // Navigator.pop(context);

      var searchTerms = SearchTerms(
        searchType: SearchTerms.searchTypeVersion,
        groupId: artifact.iG ?? '',
        artifactId: artifact.iA ?? '',
      );

      Navigator.pushNamed(
        context,
        SearchResultsPage.routeName,
        arguments: <String, SearchTerms>{
          'searchTerms': searchTerms,
        },
      );
    },
  );
}
