import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({Key? key, required this.searchTerm})
      : super(key: key);

  final String searchTerm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Results: $searchTerm")),
      body: Center(
        child: Column(
          children: <Widget>[
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
}
