import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/mavencentral/model/mcr_doc.dart';

class ArtifactDetailsAppBarMenuItemModel {
  final String prefix;
  final String label;
  final Function onSelected;

  const ArtifactDetailsAppBarMenuItemModel({
    required this.prefix,
    required this.label,
    required this.onSelected,
  });

  PopupMenuItem<ArtifactDetailsAppBarMenuItemModel> buildPopupMenuItem(
      MCRDoc artifact) {
    String myLabel = prefix == 'V'
        ? 'Search by All ${artifact.iVersionCount} Versions'
        : label;

    return PopupMenuItem<ArtifactDetailsAppBarMenuItemModel>(
      value: this,
      child: Builder(builder: (context) {
        return Row(
          children: [
            Text(
              '$prefix:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 8),
            Text(myLabel),
          ],
        );
      }),
    );
  }
}
