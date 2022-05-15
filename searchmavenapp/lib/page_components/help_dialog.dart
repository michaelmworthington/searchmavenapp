import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'help_dialog_content.dart';

//from:
//   - ./res/menu/help_dialog.xml
//https://docs.flutter.io/flutter/material/SimpleDialog-class.html
class HelpDialog extends StatelessWidget {
  const HelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: adaptive return CupertinoAlertDialog(
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const Icon(
              Icons.help_outline,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              "Help",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      content: const HelpDialogContent(),
      actions: [
        TextButton(
          child: const Text("Close"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
