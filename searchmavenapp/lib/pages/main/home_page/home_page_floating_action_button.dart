import 'package:flutter/material.dart';

class HomePageFloatingActionButton extends StatelessWidget {
  final Function submitSearch;

  const HomePageFloatingActionButton({
    Key? key,
    required this.submitSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: () {
          submitSearch();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/icon/icon_search_transparent.png',
            fit: BoxFit.fill,
          ),
        ),
        // child: const Icon(Icons.search),
      );
}
