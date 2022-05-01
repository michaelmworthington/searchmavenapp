import 'package:flutter/material.dart';

class HomePageNavigationDrawerListTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function onTap;

  const HomePageNavigationDrawerListTile({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(label),
        leading: Icon(icon),
        onTap: () {
          // Always close the drawer
          Navigator.pop(context);
          // Now do whatever action when an item is clicked
          onTap();
        },
      );
}
