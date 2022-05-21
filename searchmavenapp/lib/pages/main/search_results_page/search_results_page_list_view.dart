import 'package:flutter/material.dart';
import 'package:searchmavenapp/api/mavencentral/model/mavencentralresponse.dart';

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../test/sample_fourth_page/sample_fourth_page.dart';
import '../../test/sample_second_page/sample_second_page.dart';
import '../../test/sample_third_page/sample_third_page.dart';
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
              Text("Items: $itemCount of $totalNumFound"),
            ],
          ),
          Flexible(
            child: GridView.count(
              crossAxisCount: 1,
              padding: const EdgeInsets.all(16.0),
              // ield identifies the size of the items based on an aspect ratio (width over height).
              childAspectRatio: 16.0 / 6.0, //deal with overflow
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'GroupId: ${pArtifact.iG}',
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis, //TODO: this truncates long lines
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'ArtifactId: ${pArtifact.iA}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic, color: Colors.red),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Latest Version: ${pArtifact.iLatestVersion}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Latest Release: ' +
                        DateTime.fromMillisecondsSinceEpoch(
                                pArtifact.iTimestamp ?? 0)
                            .toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
