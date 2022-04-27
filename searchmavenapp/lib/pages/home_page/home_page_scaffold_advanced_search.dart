import 'package:flutter/material.dart';

class HomePageScaffoldAdvancedSearch extends StatelessWidget {
  const HomePageScaffoldAdvancedSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Advanced Search',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
        ),
      );
}
