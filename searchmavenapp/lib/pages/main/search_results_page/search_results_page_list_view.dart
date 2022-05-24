import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/mavencentral/model/mavencentralresponse.dart';

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../samples/sample_fourth_page/sample_fourth_page.dart';
import '../../samples/sample_second_page/sample_second_page.dart';
import '../../samples/sample_third_page/sample_third_page.dart';
import '../artifact_details_page/artifact_details_page.dart';

class SearchResultsPageListView extends StatelessWidget {
  final MavenCentralResponse? data;

  const SearchResultsPageListView({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalNumFound = data?.response.numFound ?? 0;
    int itemCount = data?.response.docs.length ?? 0;
    // return Text('Robust API Nullable Data: $numFound');

    return Flexible(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16.0),
              Text("Items: $itemCount of $totalNumFound"),
            ],
          ),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(4.0),
              children: _buildGridCards2(context, data?.response.docs ?? []),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGridCards2(BuildContext context, List<MCRDoc> pArtifacts) {
    return pArtifacts.map((artifact) {
      return _createArtifactCard(context, artifact);
    }).toList();
  }

  Widget _createArtifactCard(BuildContext context, MCRDoc pArtifact) {
    //from:
    //    - ./res/layout/search_results_item.xml
    //TODO: more styling and deal with childAspectRatio overflow
    //    whatever styling works best, but the android version had
    //    2 rows with groupid/artifactid left aligned and latest version and date right alighed
    //    groupid would wrap when it reached the version
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArtifactDetailsPage(iArtifact: pArtifact))),
      onLongPress: () => showDialog(
          context: context,
          builder: (context) => _dialogBuilderLongPress(context, pArtifact)),
      child: Card(
        elevation: 10.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _myEllipsisText(
                    'GroupId',
                    pArtifact.iG,
                    Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8.0),
                  _myEllipsisText(
                    'ArtifactId',
                    pArtifact.iA,
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic, color: Colors.red),
                  ),
                  const SizedBox(height: 8.0),
                  _myEllipsisText(
                    'Latest Version',
                    pArtifact.iLatestVersion,
                    Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8.0),
                  _myEllipsisText(
                    'Latest Release',
                    DateTime.fromMillisecondsSinceEpoch(
                            pArtifact.iTimestamp ?? 0)
                        .toString(),
                    Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _myEllipsisText(
    String pLabel,
    String? pValue,
    TextStyle? pStyle,
  ) {
    return Text(
      '$pLabel: ${pValue?.replaceAll('', '\u{200B}')}', //TODO: workaround for ellipsis - replace each with tiny-space unicode - https://github.com/flutter/flutter/issues/18761
      style: pStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis, //TODO: this truncates long lines
      // overflow: TextOverflow.fade,
      // softWrap: false,
    );
  }

  Widget _dialogBuilderLongPress(BuildContext pContext, MCRDoc pArtifact) {
    //from:
    //   - ./res/menu/search_results_context_menu.xml
    //   - TODO: java class?
    //https://docs.flutter.io/flutter/material/SimpleDialog-class.html
    return SimpleDialog(title: const Text("Search By:"), //TODO: Styling
        children: <Widget>[
          SimpleDialogOption(
            child: const Text("Group Id"), //TODO: make bigger and add padding
            onPressed: () {
              Navigator.pop(pContext);
              //TODO: Group Id Search
              Navigator.push(
                  pContext,
                  MaterialPageRoute(
                      builder: (context) =>
                          SampleSecondPage(counter: 3, searchTerm: "menu")));
            },
          ),
          SimpleDialogOption(
            child: const Text("Artifact Id"),
            onPressed: () {
              //Close the drawer
              Navigator.pop(pContext);
              //TODO: artifact id search
              Navigator.push(
                  pContext,
                  MaterialPageRoute(
                      builder: (context) => const SampleThirdPage()));
            },
          ),
          SimpleDialogOption(
            child:
                Text("All " + pArtifact.iVersionCount.toString() + " Versions"),
            onPressed: () {
              //Close the drawer
              Navigator.pop(pContext);
              //TODO: All Versions search
              Navigator.push(
                  pContext,
                  MaterialPageRoute(
                      builder: (context) => const SampleFourthPage()));
            },
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.pop(pContext);
              },
              child: const Text("Close"),
            ),
          )
        ]);
  }
}
