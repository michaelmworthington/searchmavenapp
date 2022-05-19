import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../../api/mavencentral/mavencentralsearchapi.dart';
import '../../../api/mavencentral/model/mavencentralresponse.dart';

class SearchResultsPage extends StatefulWidget {
  final bool isDemoMode;
  final int numResults;
  final String searchType;
  final String quickSearch;
  final String groupId;
  final String artifactId;
  final String version;
  final String packaging;
  final String classifier;
  final String classname;

  const SearchResultsPage({
    Key? key,
    required this.isDemoMode,
    required this.numResults,
    required this.searchType,
    required this.quickSearch,
    required this.groupId,
    required this.artifactId,
    required this.version,
    required this.packaging,
    required this.classifier,
    required this.classname,
  }) : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<MavenCentralResponse> dataFuture;

  @override
  void initState() {
    super.initState();

    //TODO: Advanced Search
    //TODO: Search Terms Model Class
    dataFuture = CentralSearchAPI().search(
      pSearchQueryString: widget.quickSearch,
      pNumResults: widget.numResults,
      pDemoMode: widget.isDemoMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement Advanced Search - look into parsing/forming the URL in the API Class
    if (widget.searchType == 'Advanced') {
      return Scaffold(
        appBar: AppBar(title: Text("${widget.searchType} Search Results")),
        body: _buildSearchNotAllowedMessage(context),
      );
    }

    //from:
    //    - ./res/layout/search_results.xml
    return Scaffold(
      appBar: AppBar(title: Text("${widget.searchType} Search Results:")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () => setState(
          () {
            dataFuture = CentralSearchAPI().search(
              pSearchQueryString: widget.quickSearch,
              pNumResults: widget.numResults,
              pDemoMode: widget.isDemoMode,
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            "Quick" == widget.searchType
                ? _buildSearchTermRow("Quick Search: ", widget.quickSearch)
                : _buildAdvancedSearchRow(),
            const SizedBox(
              height: 24,
            ),
            Center(
              child: FutureBuilder<MavenCentralResponse>(
                future:
                    dataFuture, //DO THIS - static instance of the data, until it's forced to refresh
                builder: (context, snapshot) {
                  //handle no data vs. in process separately
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Wrap(
                        children: const [
                          Text('Robust API Value Waiting : '),
                          CircularProgressIndicator.adaptive(),
                        ],
                      );
                    case ConnectionState.done:
                    default:
                      if (snapshot.hasError) {
                        final error = snapshot.error;
                        debugPrintStack(stackTrace: snapshot.stackTrace);

                        return Text('Robust API Nullable Error: $error');
                      } else if (snapshot.hasData) {
                        int data = snapshot.data?.response.numFound ?? 0;
                        return Text('Robust API Nullable Data: $data');
                      } else {
                        return const Text('Robust API Value No Data');
                      }
                  }
                },
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              label: const Text('SetState'),
            ),
            const Divider(color: Colors.red),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              label: const Text("Go Back"),
              icon: const Icon(Icons.keyboard_backspace),
            ),
            const SizedBox(height: 16)
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
              _buildSearchTermRow("GroupId: ", widget.groupId),
              _buildSearchTermRow("ArtifactId: ", widget.artifactId),
              _buildSearchTermRow("Version: ", widget.version),
              _buildSearchTermRow("Packaging: ", widget.packaging),
              _buildSearchTermRow("Classifier: ", widget.classifier),
              _buildSearchTermRow("Classname: ", widget.classname),
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
        // Text("Only quick search allowed", style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColor)),
        const SizedBox(height: 12.0),
        Text("Search Type: ${widget.searchType}"),
        const SizedBox(height: 12.0),
        Text("quickSearch: ${widget.quickSearch}"),
        const SizedBox(height: 12.0),
        Text("groupId: ${widget.groupId}"),
        const SizedBox(height: 12.0),
        Text("artifactId: ${widget.artifactId}"),
        const SizedBox(height: 12.0),
        Text("version: ${widget.version}"),
        const SizedBox(height: 12.0),
        Text("packaging: ${widget.packaging}"),
        const SizedBox(height: 12.0),
        Text("classifier: ${widget.classifier}"),
        const SizedBox(height: 12.0),
        Text("classname: ${widget.classname}"),
      ],
    );
  }
}
