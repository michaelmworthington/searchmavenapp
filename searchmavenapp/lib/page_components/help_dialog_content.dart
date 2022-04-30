import 'package:flutter/material.dart';

class HelpDialogContent extends StatelessWidget {
  const HelpDialogContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Style for Cupertino
    // return Wrap(
    //   children: const [
    //     Text('Tap search results to view artifact information'),
    //     Text(
    //         "Long press to search by group id, artifact id, or show all versions"),
    //   ],
    // );

    return Wrap(
      children: const [
        ListTile(
          leading: Icon(Icons.label_outline_rounded),
          title: Text('Tap search results to view artifact information'),
        ),
        ListTile(
          leading: Icon(Icons.label_outline_rounded),
          title: Text(
              "Long press to search by group id, artifact id, or show all versions"),
        ),
      ],
    );
  }
}
