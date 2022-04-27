import 'package:flutter/material.dart';

// https://www.youtube.com/watch?v=17FLO6uHhHU
// https://flutter.io/docs/cookbook/design/drawer

class HomePageNavigationDrawer extends StatelessWidget {
  final TabController tabController;

  const HomePageNavigationDrawer({Key? key, required this.tabController})
      : super(key: key);

  //from:
  //    - ./res/menu/menu.xml
  @override
  Widget build(BuildContext context) => Drawer(
        //TODO: how does it scroll?? maybe use a column
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildNavigationDrawerHeader(context),
              _buildNavigationDrawerItems(context),
            ],
          ),
        ),
      );

  _buildNavigationDrawerHeader(BuildContext context) => DrawerHeader(
        child: Column(
          children: const [
            CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage(
                  "https://lh4.googleusercontent.com/OIvMPFrURaPBUEno3A1K1pmoNfPfg52TP2XKVc_fN9aQAuQrjefpCxJVIpK9niYm8SpLaw=w1280"),
            ),
            SizedBox(height: 12),
            Text("Drawer Header"), //TODO: Info or picture
          ],
        ),
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      );

  _buildNavigationDrawerItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        child: Wrap(
          runSpacing: 4,
          children: [
            HomePageNavigationDrawerListTile(
                label: "Quick Search",
                icon: Icons.search,
                onTap: () {
                  tabController.index = 0;
                }),
            HomePageNavigationDrawerListTile(
                label: "Advanced Search",
                icon: Icons.youtube_searched_for,
                onTap: () {
                  tabController.index = 1;
                }),
            HomePageNavigationDrawerListTile(
                label: "Help", icon: Icons.help, onTap: () {}),
            HomePageNavigationDrawerListTile(
                label: "Settings", icon: Icons.settings, onTap: () {}),
            HomePageNavigationDrawerListTile(
                label: "About", icon: Icons.info, onTap: () {}),
            const Divider(color: Colors.black54),
            HomePageNavigationDrawerListTile(
                label: "Remove Things Below", icon: Icons.clear, onTap: () {}),
            HomePageNavigationDrawerListTile(
                label: "Second", icon: Icons.book, onTap: () {}),
            HomePageNavigationDrawerListTile(
                label: "Third", icon: Icons.play_arrow, onTap: () {}),
            HomePageNavigationDrawerListTile(
                label: "Fourth", icon: Icons.play_circle_outline, onTap: () {}),
          ],
        ),
      );
}

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
          Navigator.pop(context);
          onTap();
        },
      );
}
