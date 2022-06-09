import 'package:flutter/material.dart';

import '../../samples/sample_fourth_page/sample_fourth_page.dart';
import '../../samples/sample_second_page/sample_second_page.dart';
import '../../samples/sample_third_page/sample_third_page.dart';
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
    onSelected: (BuildContext context) {
      Navigator.pop(context);
      Navigator.pop(context);
      //TODO: Group Id Search
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SampleSecondPage(counter: 3, searchTerm: "menu")));
    },
  );

  static final itemArtifactId = ArtifactDetailsAppBarMenuItemModel(
    prefix: 'A',
    label: 'Search by Artifact Id',
    onSelected: (BuildContext context) {
      Navigator.pop(context);
      Navigator.pop(context);
      //TODO: Artifact Id Search
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SampleThirdPage()));
    },
  );

  static final itemVersions = ArtifactDetailsAppBarMenuItemModel(
    prefix: 'V',
    label: 'Search All Versions',
    onSelected: (BuildContext context) {
      Navigator.pop(context);
      Navigator.pop(context);
      //TODO: Version Id Search
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SampleFourthPage()));
    },
  );
}
