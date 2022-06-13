import 'package:flutter/material.dart';

import '../../../api/mavencentral/mavencentralsearchapi.dart';
import '../../../api/mavencentral/model/mavencentralresponse.dart';
import '../../../api/mavencentral/model/mcr_doc.dart';
import '../home_page/home_page_search_terms.dart';
import 'search_results_page_list_view.dart';

class SearchResultsPage extends StatefulWidget {
  final bool isDemoMode;
  final int numResults;
  final SearchTerms searchTerms;

  const SearchResultsPage({
    Key? key,
    required this.isDemoMode,
    required this.numResults,
    required this.searchTerms,
  }) : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<MavenCentralResponse> dataFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool shouldShowFullScreenRefresh = true;
  bool hasMoreData = true;
  bool isLoading = false;
  final controller = ScrollController();

  List<MCRDoc> artifactList = [];
  List<MCRDoc> newArtifactList = [];

  @override
  void initState() {
    super.initState();

    //for infinite list
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (hasMoreData) {
          _performSearch();
        }
      }
    });

    shouldShowFullScreenRefresh = true;
    _onRefresh();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Future _onRefresh() {
    // initialize an empty result list and do the first search
    setState(() {
      isLoading = false;
      hasMoreData = true;
      artifactList = [];
    });
    return _performSearch();
  }

  Future _performSearch() {
    if (isLoading) {
      // don't make another call, just return an immediate future
      return Future.delayed(const Duration(seconds: 0));
    }

    setState(
      () {
        //TODO: Advanced Search

        isLoading = true;
        newArtifactList = [];

        dataFuture = CentralSearchAPI().search(
          pSearchQueryString: widget.searchTerms.quickSearch,
          pContext: context,
          pNumResults: widget.numResults,
          pStart: artifactList.length,
          pDemoMode: widget.isDemoMode,
        );
      },
    );

    return dataFuture;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement Advanced Search - look into parsing/forming the URL in the API Class
    if (widget.searchTerms.isQuickSearch() == false) {
      return Scaffold(
        appBar: AppBar(
          title: Text("${widget.searchTerms.searchType} Search Results"),
        ),
        body: _buildSearchNotAllowedMessage(context),
      );
    }

    //from:
    //    - ./res/layout/search_results.xml
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.searchTerms.searchType} Search Results"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: () {
          shouldShowFullScreenRefresh = true;
          _onRefresh();
        },
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8.0),
            Row(
              children: [
                const SizedBox(width: 16.0),
                widget.searchTerms.isQuickSearch()
                    ? _buildSearchTermRow(
                        "Quick Search (demo = ${widget.isDemoMode}): ",
                        widget.searchTerms.quickSearch)
                    : _buildAdvancedSearchRow(),
              ],
            ),
            const SizedBox(height: 8.0),
            FutureBuilder<MavenCentralResponse>(
              future:
                  //call the API outside of build - init state - https://flutter.io/docs/cookbook/networking/fetch-data#5-moving-the-fetch-call-out-of-the-build-method
                  //DO THIS - static instance of the data, until it's forced to refresh
                  dataFuture,
              builder: (context, snapshot) {
                //handle no data vs. in process separately
                if (shouldShowFullScreenRefresh &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  // By default, show a loading spinner
                  // from:
                  //     - ./res/layout/search_results_progress_item.xml
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Text('Robust API Value Waiting : '),
                        const CircularProgressIndicator.adaptive(),
                        const SizedBox(height: 16),
                        Text(
                          "Searching search.maven.org", //TODO: Change if not searching central
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  final error = snapshot.error;
                  debugPrintStack(stackTrace: snapshot.stackTrace);

                  return Text('API Error: $error');
                }

                if (snapshot.hasData) {
                  //protect against multiple callbacks
                  if (isLoading &&
                      snapshot.connectionState == ConnectionState.done) {
                    newArtifactList = snapshot.data?.response.docs ?? [];

                    isLoading = false;
                    shouldShowFullScreenRefresh = false;

                    if (newArtifactList.length < widget.numResults) {
                      hasMoreData = false;
                    }
                    artifactList.addAll(newArtifactList);
                  }

                  return SearchResultsPageListView(
                    artifactList: artifactList,
                    totalNumFound: snapshot.data?.response.numFound ?? 0,
                    refreshIndicatorKey: _refreshIndicatorKey,
                    onRefresh: _onRefresh,
                    hasMoreData: hasMoreData,
                    controller: controller,
                  );
                } else {
                  return const Text('API Value No Data');
                }
              },
            ),
            // const Spacer(),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     setState(() {});
            //   },
            //   icon: const Icon(Icons.refresh),
            //   label: const Text('SetState'),
            // ),
            // const Divider(color: Colors.red),
            // ElevatedButton.icon(
            //   onPressed: () => Navigator.pop(context),
            //   label: const Text("Go Back"),
            //   icon: const Icon(Icons.keyboard_backspace),
            // ),
            // const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTermRow(String pLabel, String pValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(pLabel),
        Text(pValue),
      ],
    );
  }

  Widget _buildAdvancedSearchRow() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchTermRow("GroupId: ", widget.searchTerms.groupId),
              _buildSearchTermRow(
                  "ArtifactId: ", widget.searchTerms.artifactId),
              _buildSearchTermRow("Version: ", widget.searchTerms.version),
              _buildSearchTermRow("Packaging: ", widget.searchTerms.packaging),
              _buildSearchTermRow(
                  "Classifier: ", widget.searchTerms.classifier),
              _buildSearchTermRow("Classname: ", widget.searchTerms.classname),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSearchNotAllowedMessage(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        Text("Only quick search allowed",
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Theme.of(context).primaryColor)),
        // Text("Only quick search allowed", style: Theme.of(context).textTheme.headline.copyWith(color:
        // Theme.of(context).primaryColor)),
        const SizedBox(height: 12.0),
        Text("Search Type: ${widget.searchTerms.searchType}"),
        const SizedBox(height: 12.0),
        Text("quickSearch: ${widget.searchTerms.quickSearch}"),
        const SizedBox(height: 12.0),
        Text("groupId: ${widget.searchTerms.groupId}"),
        const SizedBox(height: 12.0),
        Text("artifactId: ${widget.searchTerms.artifactId}"),
        const SizedBox(height: 12.0),
        Text("version: ${widget.searchTerms.version}"),
        const SizedBox(height: 12.0),
        Text("packaging: ${widget.searchTerms.packaging}"),
        const SizedBox(height: 12.0),
        Text("classifier: ${widget.searchTerms.classifier}"),
        const SizedBox(height: 12.0),
        Text("classname: ${widget.searchTerms.classname}"),
      ],
    );
  }
}
