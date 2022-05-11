import 'package:flutter/material.dart';

import 'pages/main/home_page/home_page.dart';
import 'pages/test/sample_fifth_page/sample_fifth_page.dart';
import 'pages/test/sample_fourth_page/sample_fourth_page.dart';
import 'pages/test/sample_second_page/sample_second_page.dart';
import 'pages/test/sample_third_page/sample_third_page.dart';
import 'pages/main/search_results_page/search_results_page.dart';
import 'pages/main/settings_page/settings_page.dart';

void main() {
  //TODO: config option for debugging & control output (NOTE: search all files for print()
  //TODO: uncomment for prod builds
  //      https://stackoverflow.com/questions/49475550/how-to-disable-all-logs-debugprint-in-release-build-in-flutter
  //debugPrint = (String message, {int wrapWidth}) {};
  runApp(const MyApp());
}

//The Scaffolding and Look-and-Feel Theme for the app
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    _themeMode = ThemeMode.system;
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Maven App',
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      theme: _buildTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
      // don't define home when using a named route with '/'
      // home: const MyHomePage(title: 'Search Maven App'),
      initialRoute: '/',
      // mmw: i'm using these for pages that don't require any arguments, or use
      //      ModalRoute.of(context)!.settings.arguments to extract the arguments
      routes: {
        '/': (context) => const MyHomePage(title: 'Search Maven App'),
        '/settings': (context) => SettingsPage(changeTheme: _changeThemeMode),
        '/sample_third': (context) => const SampleThirdPage(),
        '/sample_fourth': (context) => const SampleFourthPage(),
        '/sample_fifth': (context) => const SampleFifthPage(),
      },
      // mmw: these pages require arguments on the Widget constructor
      //      https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/sample_second') {
          final args = settings.arguments as Map<String, String>;

          return MaterialPageRoute(
            builder: (context) {
              return SampleSecondPage(
                searchTerm: args['searchTerm'] ?? '',
                counter: int.parse(args['counter'] ?? '100'),
              );
            },
          );
        }

        if (settings.name == '/search_results') {
          final args = settings.arguments as Map<String, String>;

          return MaterialPageRoute(
            builder: (context) {
              return SearchResultsPage(
                searchType: args['searchType'] ?? '',
                quickSearch: args['quickSearch'] ?? '',
                groupId: args['groupId'] ?? '',
                artifactId: args['artifactId'] ?? '',
                version: args['version'] ?? '',
                packaging: args['packaging'] ?? '',
                classifier: args['classifier'] ?? '',
                classname: args['classname'] ?? '',
              );
            },
          );
        }

        // The code only supports
        // PassArgumentsScreen.routeName right now.
        // Other values need to be implemented if we
        // add them. The assertion here will help remind
        // us of that higher up in the call stack, since
        // this assertion would otherwise fire somewhere
        // in the framework.
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }

  void _changeThemeMode(String pThemeMode) {
    setState(() {
      switch (pThemeMode) {
        case 'Light':
          _themeMode = ThemeMode.light;
          break;
        case 'Dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
    });
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      primarySwatch: _buildCustomPrimaryColor(),
      brightness: Brightness.dark,
      primaryColor: _buildCustomPrimaryColorDark(),
      accentColor: Colors.grey,
      // colorScheme: ColorScheme.dark(),
      // canvasColor: Colors.blue,
      inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
      // buttonColor: Colors.blueGrey,
      // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      //iconTheme: IconThemeData(
      //  color: Colors.red
      //),
      //bottomAppBarColor: Colors.red,
      //cardColor: Colors.red
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _buildCustomPrimaryColor(),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      // primarySwatch: Colors.blueGrey,
      // primarySwatch: Color(0xff686868),
      // primarySwatch: Color.fromARGB(255, 104, 104, 104),
      primarySwatch: _buildCustomPrimaryColorFromTranslatedIcon(),
      brightness: Brightness.light,
      primaryColor: _buildCustomPrimaryColorFromTranslatedIcon(),
      accentColor: Colors.grey,
      // canvasColor: Colors.blueGrey,
      inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
      buttonColor: Colors.blueGrey,
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      //iconTheme: IconThemeData(
      //  color: Colors.red
      //),
      //bottomAppBarColor: Colors.red,
      //cardColor: Colors.red
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _buildCustomPrimaryColorFromTranslatedIcon(),
      ),
    );
  }

  // # 686868
  MaterialColor _buildCustomPrimaryColor() {
    Map<int, Color> color = const {
      50: Color.fromRGBO(104, 104, 104, .1),
      100: Color.fromRGBO(104, 104, 104, .2),
      200: Color.fromRGBO(104, 104, 104, .3),
      300: Color.fromRGBO(104, 104, 104, .4),
      400: Color.fromRGBO(104, 104, 104, .5),
      500: Color.fromRGBO(104, 104, 104, .6),
      600: Color.fromRGBO(104, 104, 104, .7),
      700: Color.fromRGBO(104, 104, 104, .8),
      800: Color.fromRGBO(104, 104, 104, .9),
      900: Color.fromRGBO(104, 104, 104, 1),
    };

    return MaterialColor(0xFF686868, color);
  }

  // # 5D5D5D
  MaterialColor _buildCustomPrimaryColorFromTranslatedIcon() {
    Map<int, Color> color = const {
      50: Color.fromRGBO(93, 93, 93, .1),
      100: Color.fromRGBO(93, 93, 93, .2),
      200: Color.fromRGBO(93, 93, 93, .3),
      300: Color.fromRGBO(93, 93, 93, .4),
      400: Color.fromRGBO(93, 93, 93, .5),
      500: Color.fromRGBO(93, 93, 93, .6),
      600: Color.fromRGBO(93, 93, 93, .7),
      700: Color.fromRGBO(93, 93, 93, .8),
      800: Color.fromRGBO(93, 93, 93, .9),
      900: Color.fromRGBO(93, 93, 93, 1),
    };

    return MaterialColor(0xFF5D5D5D, color);
  }

  // # 303030
  MaterialColor _buildCustomPrimaryColorDark() {
    Map<int, Color> color = const {
      50: Color.fromRGBO(48, 48, 48, .1),
      100: Color.fromRGBO(48, 48, 48, .2),
      200: Color.fromRGBO(48, 48, 48, .3),
      300: Color.fromRGBO(48, 48, 48, .4),
      400: Color.fromRGBO(48, 48, 48, .5),
      500: Color.fromRGBO(48, 48, 48, .6),
      600: Color.fromRGBO(48, 48, 48, .7),
      700: Color.fromRGBO(48, 48, 48, .8),
      800: Color.fromRGBO(48, 48, 48, .9),
      900: Color.fromRGBO(48, 48, 48, 1),
    };

    return MaterialColor(0xFF303030, color);
  }
}
