import 'package:flutter/material.dart';

class HomePageScaffoldQuickSearch extends StatelessWidget {
  final GlobalKey<FormState> formStateKey;

  const HomePageScaffoldQuickSearch({
    Key? key,
    required this.formStateKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Form(
          key: formStateKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Quick Search',
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Search term is required';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    debugPrint("Searching for: ${value}");

                    Navigator.pushNamed(
                      context,
                      '/search_results',
                      arguments: <String, String>{
                        'searchTerm': value,
                      },
                    );
                  },
                ),
                // const SizedBox(
                //   height: 96,
                // ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        debugPrint("clear button pressed");
                      },
                      child: const Text("CLEAR"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        debugPrint("searching");

                        Navigator.pushNamed(
                          context,
                          '/search_results',
                          arguments: <String, String>{
                            'searchTerm': "???",
                          },
                        );
                      },
                      child: const Icon(Icons.search),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
