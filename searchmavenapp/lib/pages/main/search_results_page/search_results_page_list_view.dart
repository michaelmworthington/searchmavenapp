import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchmavenapp/api/mavencentral/model/mavencentralresponse.dart';

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../../page_components/artifact_field_text_ellipsis.dart';
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
    //finished for now: more styling and deal with childAspectRatio overflow
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
                  ArtifactFieldTextEllipsis(
                    label: 'Group Id',
                    value: '${pArtifact.iG}',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8.0),
                  ArtifactFieldTextEllipsis(
                    label: 'Artifact Id',
                    value: '${pArtifact.iA}',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8.0),
                  ArtifactFieldTextEllipsis(
                    label: 'Latest Version',
                    value: '${pArtifact.iLatestVersion}',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    valueStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8.0),
                  ArtifactFieldTextEllipsis(
                    label: 'Latest Release',
                    value: DateFormat("yyyy-MMM-dd").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          pArtifact.iTimestamp ?? 0),
                    ),
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    valueStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8.0),
                  ArtifactFieldTextEllipsis(
                    label: 'Total Versions',
                    value: '${pArtifact.iVersionCount}',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    valueStyle: Theme.of(context).textTheme.bodySmall,
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
    return SimpleDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        color: Theme.of(pContext).primaryColor,
        padding: const EdgeInsets.all(24),
        child: Text(
          "Search By:",
          style: Theme.of(pContext)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.white),
        ),
      ),
      children: <Widget>[
        SimpleDialogOption(
          child: Text(
            "Group Id",
            style: Theme.of(pContext).textTheme.titleLarge,
          ),
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
          child: Text(
            "Artifact Id",
            style: Theme.of(pContext).textTheme.titleLarge,
          ),
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
          child: Text(
            "All " + pArtifact.iVersionCount.toString() + " Versions",
            style: Theme.of(pContext).textTheme.titleLarge,
          ),
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
      ],
    );
  }
}
