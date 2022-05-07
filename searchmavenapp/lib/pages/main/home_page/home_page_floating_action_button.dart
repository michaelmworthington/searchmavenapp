import 'package:flutter/material.dart';

class HomePageFloatingActionButton extends StatelessWidget {
  final GlobalKey<FormState> formStateKey;
  final TextEditingController quickSearchTextController;

  const HomePageFloatingActionButton({Key? key, required this.formStateKey, required this.quickSearchTextController})
      : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: () {
          if (formStateKey.currentState!.validate()) {
            formStateKey.currentState!.save();
            debugPrint("Search Submitted");

            Navigator.pushNamed(
              context,
              '/search_results',
              arguments: <String, String>{
                'searchTerm': quickSearchTextController.text,
              },
            );
          }
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
