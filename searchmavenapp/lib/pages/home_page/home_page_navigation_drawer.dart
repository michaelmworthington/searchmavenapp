import 'package:flutter/material.dart';

import '../../page_components/about_dialog.dart';
import '../../page_components/help_dialog.dart';
import 'home_page_navigation_drawer_list_tile.dart';

// Johannes Milke - https://www.youtube.com/watch?v=17FLO6uHhHU
// https://flutter.io/docs/cookbook/design/drawer

class HomePageNavigationDrawer extends StatelessWidget {
  final TabController tabController;
  final String myAppTitle;

  const HomePageNavigationDrawer(
      {Key? key, required this.tabController, required this.myAppTitle})
      : super(key: key);

  //from:
  //    - ./res/menu/menu.xml
  @override
  Widget build(BuildContext context) => Drawer(
        //TODO: scrolls all as one - make it fancy minimizing and fading the header
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
              backgroundImage: AssetImage('assets/icon/icon.png'),
              // backgroundImage: NetworkImage(
              //     "https://raw.githubusercontent.com/michaelmworthington/searchmavenapp/master/Assets/Android/searchmaven_512.png"),
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
                tabController.index = 0; //TODO: Use Navigator Routes??
              },
            ),
            HomePageNavigationDrawerListTile(
              label: "Advanced Search",
              icon: Icons.youtube_searched_for,
              onTap: () {
                tabController.index = 1; //TODO: Use Navigator Routes??
              },
            ),
            HomePageNavigationDrawerListTile(
              label: "Help",
              icon: Icons.help,
              onTap: () {
                //TODO: adaptive showCupertinoDialog(
                showDialog(
                    context: context, builder: (context) => const HelpDialog());
              },
            ),
            HomePageNavigationDrawerListTile(
              label: "Settings",
              icon: Icons.settings,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/settings',
                );
              },
            ),
            HomePageNavigationDrawerListTile(
              label: "About",
              icon: Icons.info,
              onTap: () {
                //TODO: adaptive showCupertinoDialog(
                showDialog(
                  context: context,
                  builder: (context) => MyAboutDialog(myAppTitle: myAppTitle),
                );
              },
            ),
            // Divider
            const Divider(
              color: Colors.black54,
            ),
            // Next Section
            HomePageNavigationDrawerListTile(
              label: "Remove Things Below",
              icon: Icons.clear,
              onTap: () {},
            ),
            HomePageNavigationDrawerListTile(
              label: "Second",
              icon: Icons.book,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/sample_second',
                  arguments: <String, String>{
                    'searchTerm': 'menu',
                    'counter': '75',
                  },
                );
              },
            ),
            HomePageNavigationDrawerListTile(
              label: "Third",
              icon: Icons.play_arrow,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/sample_third',
                );
              },
            ),
            HomePageNavigationDrawerListTile(
              label: "Fourth",
              icon: Icons.play_circle_outline,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/sample_fourth',
                );
              },
            ),
            HomePageNavigationDrawerListTile(
              label: "Fifth",
              icon: Icons.play_for_work,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/sample_fifth',
                );
              },
            ),
          ],
        ),
      );
}
