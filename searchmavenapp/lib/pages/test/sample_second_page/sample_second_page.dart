import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    as font_awesome_flutter;

class SampleSecondPage extends StatelessWidget {
  SampleSecondPage({Key? key, this.counter = 0, required this.searchTerm})
      : super(key: key) {
    debugPrint("counter was $counter");
  }

  final int counter;
  final String searchTerm;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    print('MyArgs: ${args}');

    return Scaffold(
      appBar: AppBar(title: Text("second screen: $searchTerm")),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: counter,
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
              icon: const Icon(
                  font_awesome_flutter.FontAwesomeIcons.backwardStep),
            ),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
