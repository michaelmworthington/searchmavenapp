import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$searchType Search Results:")),
      body: Center(
        child: Column(
          children: <Widget>[
            "Quick" == searchType
                ? _buildSearchTermRow("Quick Search: ", quickSearch)
                : _buildAdvancedSearchRow(),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text("Name of item: $index"),
                  );
                },
              ),
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

  Row _buildSearchTermRow(String pLabel, String pValue) {
    return Row(
      children: [
        Text(pLabel),
        Text(pValue),
      ],
    );
  }

  Row _buildAdvancedSearchRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildSearchTermRow("GroupId: ", groupId),
            _buildSearchTermRow("ArtifactId: ", artifactId),
            _buildSearchTermRow("Version: ", version),
            _buildSearchTermRow("Packaging: ", packaging),
            _buildSearchTermRow("Classifier: ", classifier),
            _buildSearchTermRow("Classname: ", classname),
          ],
        )
      ],
    );
  }
}
