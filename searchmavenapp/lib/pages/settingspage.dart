import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: _buildSettingsView(context)
    );
  }

  Widget _buildSettingsView(BuildContext context) {
    //from:
    //    - ./res/xml/preferences.xml
    //    - ./src/com/searchmavenapp/android/maven/search/activities/Preferences.java
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      children: <Widget>[
        ListTile(
          isThreeLine: true,
          enabled: true,
          title: Text("Demo Mode"),
          subtitle: Text("Perform a demo. Don't actually connect to Maven Central. Shows Sample Results."),
        ),
        ListTile(
          isThreeLine: true,
          enabled: true,
          title: Text("Num Results"),
          subtitle: Text("The number of search results to retrieve upon each request from Maven Central. A lower number will result in the search results fetching additional records more often, but results will come back quicker."),
        ),
        ListTile(
          isThreeLine: true,
          enabled: false,
          title: Text("Nexus URL"),
          subtitle: Text("Search this Nexus URL instead of Maven Central. (Disabled-Future Enhancement)"),
        ),
      ],
    );
  }
}
