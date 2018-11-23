import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as font_awesome_flutter;
import 'package:searchmavenapp/pages/searchresultspage.dart';



class SecondPage extends StatelessWidget {
  SecondPage({int pCounter}){
    print("counter was $pCounter");
    _counter = pCounter;
  }

  static int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("second screen")),
        body: Center(child: 
                Column(children: <Widget>[
                  Expanded(child:
                    ListView.builder(
                      itemCount: _counter,
                      itemBuilder: (context, index) {
                        return ListTile(
                            leading: const Icon(Icons.account_circle),
                            title: Text("Name of item: $index"),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => SearchResultsPage()));
                            });
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
                  )
                ])
        )
    );
  }
}