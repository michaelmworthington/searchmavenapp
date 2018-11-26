import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as font_awesome_flutter;

class SecondPage extends StatelessWidget {
  SecondPage({int pCounter, String pSearchTerm}){
    debugPrint("counter was $pCounter");
    _counter = pCounter;
    _searchTerm = pSearchTerm;
  }

  static int _counter = 0;
  static String _searchTerm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("second screen: $_searchTerm")),
      body: Center( 
        child: Column(
          children: <Widget>[
            Expanded(child:
              ListView.builder(
                itemCount: _counter,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: Text("Name of item: $index"),
                  );
                },
              )
            ),
            Divider(color: Colors.red),

            RaisedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text("Go Back"),
              icon: new Icon(font_awesome_flutter.FontAwesomeIcons.stepBackward)
            ),
            SizedBox(height: 16)
          ]
        )
      )
    );
  }
}