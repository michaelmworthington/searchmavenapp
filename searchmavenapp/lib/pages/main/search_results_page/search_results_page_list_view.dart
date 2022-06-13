import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../../page_components/artifact_field_text_ellipsis.dart';
import '../../samples/sample_fourth_page/sample_fourth_page.dart';
import '../../samples/sample_second_page/sample_second_page.dart';
import '../../samples/sample_third_page/sample_third_page.dart';
import '../artifact_details_page/artifact_details_page.dart';

class SearchResultsPageListView extends StatelessWidget {
  final List<MCRDoc> artifactList;
  final int totalNumFound;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final Future<void> Function() onRefresh;
  final bool hasMoreData;
  final ScrollController controller;

  const SearchResultsPageListView({
    Key? key,
    required this.artifactList,
    required this.totalNumFound,
    required this.refreshIndicatorKey,
    required this.onRefresh,
    required this.hasMoreData,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Flexible(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 16.0),
                Text("Items: ${artifactList.length} of $totalNumFound"),
              ],
            ),
            Flexible(
              child: kIsWeb == false || Platform.isMacOS || Platform.isIOS
                  ? _buildIOSList(context)
                  : _buildAndroidList(context),
            ),
          ],
        ),
      );

  Widget _buildAndroidList(BuildContext context) => RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: onRefresh,
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        color: Colors.white,
        child: ListView.builder(
          controller: controller,
          padding: const EdgeInsets.all(4.0),
          itemCount: artifactList.length + 1,
          itemBuilder: (context, index) {
            return _buildArtifactCardsWithInfiniteScrolling(
              index,
              context,
            );
          },
        ),
      );

  Widget _buildIOSList(BuildContext context) => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: controller,
        slivers: [
          CupertinoSliverRefreshControl(
            key: refreshIndicatorKey,
            onRefresh: onRefresh,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(4.0),
            sliver: SliverList(
              // delegate: SliverChildListDelegate(
              //   _buildGridCards2(context, artifactList),
              // ),
              delegate: SliverChildBuilderDelegate(
                childCount: artifactList.length + 1,
                (context, index) {
                  return _buildArtifactCardsWithInfiniteScrolling(
                    index,
                    context,
                  );
                },
              ),
            ),
          ),
        ],
      );

  Widget _buildArtifactCardsWithInfiniteScrolling(
    int index,
    BuildContext context,
  ) {
    if (index < artifactList.length) {
      final artifact = artifactList[index];
      return _createArtifactCard(context, artifact, index + 1);
    } else {
      return hasMoreData
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : const SizedBox(height: 16);
    }
  }

  Widget _createArtifactCard(
    BuildContext context,
    MCRDoc pArtifact,
    int index,
  ) {
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$index.'),
                  const SizedBox(width: 8),
                  Flexible(
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
