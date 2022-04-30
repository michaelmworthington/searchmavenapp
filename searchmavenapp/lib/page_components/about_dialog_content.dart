import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher_string.dart';

//  https://pub.dev/packages/flutter_linkify
class AboutDialogContent extends StatelessWidget {
  const AboutDialogContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableLinkify(
        onOpen: _onOpen,
        text:
            'This application provides a native interface to search Maven repositories including the Maven Central repository. While this site is functional on the web, the cannonical source of searching Central is at https://search.maven.org.\n\nThis is an open source application. To contribute, visit https://www.searchmavenapp.com');
  }

  //  https://pub.dev/packages/flutter_linkify
  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunchUrlString(link.url)) {
      await launchUrlString(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}

/////////////////////////////////////////////////////////////////////////////
//  Using the url_launcher only
/////////////////////////////////////////////////////////////////////////////
        //     SelectableText.rich(
        //       TextSpan(
        //         // RichText(
        //         //   text: TextSpan(
        //         style: textStyle,
        //         children: [
        //           const TextSpan(
        //             text:
        //                 'This application provides a native interface to search Maven repositories including the Maven Central repository. While this site is functional on the web, the cannonical source of searching Central is at ',
        //           ),
        //           // WidgetSpan(
        //           //   child: SelectableText.rich(
        //           //     TextSpan(
        //           //         text:
        //           //             'This application provides a native interface to search Maven repositories including the Maven Central repository. While this site is functional on the web, the cannonical source of searching Central is at '),
        //           //   ),
        //           // ),
        //           WidgetSpan(
        //             child: Icon(Icons.email, color: Colors.blue),
        //           ),
        //           // WidgetSpan(
        //           //   child: MyLink(
        //           //     textStyle: textStyle,
        //           //     uri: 'https://search.maven.org',
        //           //   ),
        //           // ),
        //           const TextSpan(
        //             text:
        //                 '.\n\nThis is an open source application. To contribute, visit ',
        //           ),
        //           // WidgetSpan(
        //           //   child: MyLink(
        //           //       textStyle: textStyle,
        //           //       uri: 'https://www.searchmavenapp.com'),
        //           // ),
        //         ],
        //       ),
        //     ),
        //   ],
        // );


/////////////////////////////////////////////////////////////////////////////
//  Using the url_launcher only
//         Link Widget - but I couldn't get Selectable to play nice with WidgetSpans
/////////////////////////////////////////////////////////////////////////////
        // https://pub.dev/packages/url_launcher/example
        // class MyLink extends StatelessWidget {
        //   const MyLink({
        //     Key? key,
        //     required this.textStyle,
        //     required this.uri,
        //   }) : super(key: key);

        //   final TextStyle textStyle;
        //   final String uri;

        //   @override
        //   Widget build(BuildContext context) {
        //     return Link(
        //       uri: Uri.parse(uri),
        //       target: LinkTarget.blank,
        //       builder: (context, followLink) => MouseRegion(
        //         cursor: SystemMouseCursors.click,
        //         child: GestureDetector(
        //           onTap: followLink,
        //           child: Text(
        //             uri,
        //             style: textStyle.copyWith(
        //                 color: Colors.blue, decoration: TextDecoration.underline),
        //           ),
        //         ),
        //       ),
        //     );
        //   }
        // }
