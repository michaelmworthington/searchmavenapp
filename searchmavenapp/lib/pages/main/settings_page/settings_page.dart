import 'package:flutter/material.dart';

import 'settings_page_listtile_dropdown.dart';

class SettingsPage extends StatelessWidget {
  static const List<String> colorSchemeChoices = ['Light', 'Dark', 'System'];
  static const List<int> numResultsChoices = [10, 25, 50, 100];

  final Function changeTheme;
  final Function changeNumResults;
  final Function changeDemoMode;
  final String currentTheme;
  final bool isDemoMode;
  final int numResults;

  const SettingsPage({
    Key? key,
    required this.changeTheme,
    required this.changeNumResults,
    required this.changeDemoMode,
    required this.currentTheme,
    required this.isDemoMode,
    required this.numResults,
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
        MyListTileWithDropdown(
          title: "Color Scheme",
          subtitle: "The look and feel of the application.",
          dropdownChoices: colorSchemeChoices,
          dropdownValue: currentTheme,
          persistDropdownChoice: changeTheme,
        ),
        SwitchListTile.adaptive(
          isThreeLine: true,
          title: const Text("Demo Mode"),
          subtitle: const Text(
              "Perform a demo. Don't actually connect to Maven Central. Shows Sample Results."),
          value: isDemoMode,
          onChanged: (newValue) {
            debugPrint("Changing Demo Mode to: $newValue");
            changeDemoMode(newValue);
          },
        ),
        MyListTileWithDropdown(
          title: "Num Results",
          subtitle:
              "The number of search results to retrieve upon each request from Maven Central. A lower number will result in the search results fetching additional records more often, but results will come back quicker.",
          dropdownChoices: numResultsChoices,
          dropdownValue: numResults,
          persistDropdownChoice: changeNumResults,
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
