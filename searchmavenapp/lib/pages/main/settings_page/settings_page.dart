import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const List<String> items = ['Light', 'Dark', 'System'];

  final Function changeTheme;
  final String currentTheme;

  const SettingsPage({
    Key? key,
    required this.changeTheme,
    required this.currentTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // i.e. remove the back button in the app bar
        // automaticallyImplyLeading: false,
        title: const Text("Settings"),
      ),
      body: _buildSettingsView(context),
    );
  }

  Widget _buildSettingsView(BuildContext context) {
    //from:
    //    - ./res/xml/preferences.xml
    //    - ./src/com/searchmavenapp/android/maven/search/activities/Preferences.java
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        ListTile(
          isThreeLine: true,
          enabled: true,
          title: const Text("Color Scheme"),
          subtitle: const Text("The look and feel of the application."),
          trailing: DropdownButton<String>(
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    child: Text(item),
                    value: item,
                  ),
                )
                .toList(),
            value: currentTheme,
            onChanged: (item) {
              debugPrint("Changing Color Scheme to: $item");
              changeTheme(item);
            },
          ),
        ),
        const ListTile(
          isThreeLine: true,
          enabled: true,
          title: Text("Demo Mode"),
          subtitle: Text(
              "Perform a demo. Don't actually connect to Maven Central. Shows Sample Results."),
        ),
        const ListTile(
          isThreeLine: true,
          enabled: true,
          title: Text("Num Results"),
          subtitle: Text(
              "The number of search results to retrieve upon each request from Maven Central. A lower number will result in the search results fetching additional records more often, but results will come back quicker."),
        ),
        const ListTile(
          isThreeLine: true,
          enabled: false,
          title: Text("Nexus URL"),
          subtitle: Text(
              "Search this Nexus URL instead of Maven Central. (Disabled-Future Enhancement)"),
        ),
      ],
    );
  }
}
