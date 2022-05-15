import 'package:flutter/material.dart';

enum MySettings {
  themeMode(key: "themeMode", defaultValue: ThemeMode.system),
  demoMode(key: "demoMode", defaultValue: false),
  numResults(key: "numResults", defaultValue: 25);

  const MySettings({
    required this.key,
    required this.defaultValue,
  });

  final String key;
  final Object defaultValue;
}
