import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../api/mavencentral/model/mcr_doc.dart';
import '../../../page_components/artifact_field_text_ellipsis.dart';
import '../../../page_components/search_terms.dart';
import '../artifact_details_page/artifact_details_page.dart';
import 'search_results_page.dart';

class SearchResultsPageListView extends StatelessWidget {
  final SearchTerms searchTerms;
  final List<MCRDoc> artifactList;
  final int totalNumFound;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final Future<void> Function() onRefresh;
  final bool hasMoreData;
  final ScrollController controller;

  const SearchResultsPageListView({
    Key? key,
    required this.searchTerms,
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
      onTap: () => Navigator.pushNamed(
        context,
        ArtifactDetailsPage.routeName,
        arguments: <String, MCRDoc>{
          'artifact': pArtifact,
        },
      ),
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
                      children: searchTerms.isVersionSearch()
                          ? _buildVersionCardFields(pArtifact, context)
                          : _buildArtifactCardFields(pArtifact, context),
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
    //   - ProgressThread.java -> MavenCentralRestAPI.java
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
      children: _buildLongPressOptions(pContext, pArtifact)
        ..add(
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.pop(pContext);
              },
              child: const Text("Close"),
            ),
          ),
        ),
    );
  }

  List<Widget> _buildLongPressOptions(BuildContext pContext, MCRDoc pArtifact) {
    var returnValue = <Widget>[
      SimpleDialogOption(
        child: Text(
          "Group Id",
          style: Theme.of(pContext).textTheme.titleLarge,
        ),
        onPressed: () {
          Navigator.pop(pContext);

          var searchTerms = SearchTerms(
            searchType: SearchTerms.searchTypeAdvanced,
            groupId: pArtifact.iG ?? '',
          );

          Navigator.pushNamed(
            pContext,
            SearchResultsPage.routeName,
            arguments: <String, SearchTerms>{
              'searchTerms': searchTerms,
            },
          );
        },
      ),
      SimpleDialogOption(
        child: Text(
          "Artifact Id",
          style: Theme.of(pContext).textTheme.titleLarge,
        ),
        onPressed: () {
          Navigator.pop(pContext);

          var searchTerms = SearchTerms(
            searchType: SearchTerms.searchTypeAdvanced,
            artifactId: pArtifact.iA ?? '',
          );

          Navigator.pushNamed(
            pContext,
            SearchResultsPage.routeName,
            arguments: <String, SearchTerms>{
              'searchTerms': searchTerms,
            },
          );
        },
      ),
    ];

    //If we're already in a version search, don't display the option to do it again
    if (searchTerms.isVersionSearch() == false) {
      returnValue.add(
        SimpleDialogOption(
          child: Text(
            "All " + pArtifact.iVersionCount.toString() + " Versions",
            style: Theme.of(pContext).textTheme.titleLarge,
          ),
          onPressed: () {
            Navigator.pop(pContext);
            var searchTerms = SearchTerms(
              searchType: SearchTerms.searchTypeVersion,
              groupId: pArtifact.iG ?? '',
              artifactId: pArtifact.iA ?? '',
            );

            Navigator.pushNamed(
              pContext,
              SearchResultsPage.routeName,
              arguments: <String, SearchTerms>{
                'searchTerms': searchTerms,
              },
            );
          },
        ),
      );
    }

    return returnValue;
  }

  List<Widget> _buildArtifactCardFields(
          MCRDoc pArtifact, BuildContext context) =>
      <Widget>[
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
            DateTime.fromMillisecondsSinceEpoch(pArtifact.iTimestamp ?? 0),
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
      ];

  List<Widget> _buildVersionCardFields(
          MCRDoc pArtifact, BuildContext context) =>
      <Widget>[
        ArtifactFieldTextEllipsis(
          label: 'Group Id',
          value: '${pArtifact.iG}',
          maxLines: 2,
          labelStyle: Theme.of(context).textTheme.bodySmall,
          valueStyle: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8.0),
        ArtifactFieldTextEllipsis(
          label: 'Artifact Id',
          value: '${pArtifact.iA}',
          maxLines: 2,
          labelStyle: Theme.of(context).textTheme.bodySmall,
          valueStyle: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8.0),
        ArtifactFieldTextEllipsis(
          label: 'Version',
          value: '${pArtifact.iV}',
        ),
        const SizedBox(height: 8.0),
        ArtifactFieldTextEllipsis(
          label: 'Release',
          value: DateFormat("yyyy-MMM-dd").format(
            DateTime.fromMillisecondsSinceEpoch(pArtifact.iTimestamp ?? 0),
          ),
        ),
      ];
}
