import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'about_dialog_content.dart';

//from:
//   - ./res/menu/help_dialog.xml
//https://docs.flutter.io/flutter/material/SimpleDialog-class.html
class MyAboutDialog extends StatelessWidget {
  final String myAppTitle;

  const MyAboutDialog({Key? key, required this.myAppTitle}) : super(key: key);

  Future<PackageInfo> _getPackageInfo() {
    // https://dev-yakuza.posstree.com/en/flutter/package_info_plus/
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: can i move this to the top of the widget tree so it's available to all widgets, and doesn't clutter this up - this would be a good initialization task
    return FutureBuilder<PackageInfo>(
      future: _getPackageInfo(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.hasError) {
          return const Text('ERROR');
        } else if (!snapshot.hasData) {
          return const Text('Loading...');
        }

        final data = snapshot.data!;

        final ThemeData theme = Theme.of(context);
        final TextStyle textStyle = theme.textTheme.bodyText2!;

        return AboutDialog(
          applicationName: myAppTitle,
          applicationVersion: data.version,
          applicationIcon: Image.asset(
            'assets/icon/icon.png',
            width: 48,
            fit: BoxFit.fitWidth,
          ),
          // applicationIcon: Image.network(
          //     "https://raw.githubusercontent.com/michaelmworthington/searchmavenapp/master/Assets/Android/searchmaven_512.png",
          //     width: 48,
          //     fit: BoxFit.fitHeight),
          applicationLegalese:
              'Apache and Apache Maven are trademarks of the Apache Software Foundation.\n\nThe Central Repository is a service mark of Sonatype, Inc. The Central Repository at search.maven.org is intended to complement Apache Maven and should not be confused with Apache Maven.',
          children: const [
            SizedBox(height: 24),
            AboutDialogContent(),
          ],
        );
      },
    );
  }
}
