import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/groovy.dart' as groovy_language;
import 'package:highlight/languages/markdown.dart';
import 'package:highlight/languages/xml.dart';
import 'package:highlight/languages/all.dart';
import 'package:flutter_highlight/themes/darcula.dart';

import '../api/mavencentral/model/mcr_doc.dart';

enum DependencyChoices {
  maven(value: "Apache Maven"),
  groovy(value: "Gradle Groovy DSL"),
  kotlin(value: "Gradle Kotlin DSL"),
  scala(value: "Scala SBT"),
  ivy(value: "Apache Ivy"),
  grape(value: "Groovy Grape"),
  lein(value: "Leiningen"),
  buildr(value: "Apache Buildr"),
  central(value: "Maven Central Badge"),
  purl(value: "PURL"),
  bazel(value: "Bazel");

  const DependencyChoices({
    required this.value,
  });

  final String value;

  CodeController createCodeController(MCRDoc artifact) => CodeController(
        text: _generateDependencyText(artifact),
        language: _getLanguage(),
        theme: darculaTheme,
      );

  Mode? _getLanguage() {
    switch (this) {
      case DependencyChoices.maven:
        return allLanguages['xml'];
      case DependencyChoices.groovy:
        return allLanguages['groovy'];
      case DependencyChoices.kotlin:
        return allLanguages['kotlin'];
      case DependencyChoices.scala:
        return allLanguages['scala'];
      case DependencyChoices.ivy:
        return allLanguages['xml'];
      case DependencyChoices.grape:
        return allLanguages['groovy'];
      case DependencyChoices.lein:
        return allLanguages['clojure'];
      case DependencyChoices.buildr:
        return allLanguages['ruby'];
      case DependencyChoices.central:
        return allLanguages['markdown'];
      case DependencyChoices.purl:
        return null;
      case DependencyChoices.bazel:
        return null;
      default:
        return null;
    }
  }

  String _generateDependencyText(MCRDoc artifact) {
    String? groupId = artifact.iG;
    String? artifactId = artifact.iA;
    String? version = artifact.iV;

    switch (this) {
      case DependencyChoices.maven:
        return '''
<dependency>
  <groupId>$groupId</groupId>
  <artifactId>$artifactId</artifactId>
  <version>$version</version>
</dependency>
''';
      case DependencyChoices.groovy:
        return """
implementation '$groupId:$artifactId:$version'
""";
      case DependencyChoices.kotlin:
        return '''
implementation("$groupId:$artifactId:$version")
''';
      case DependencyChoices.scala:
        return '''
libraryDependencies += "$groupId" % "$artifactId" % "$version"
''';
      case DependencyChoices.ivy:
        return '''
<dependency org="$groupId" name="$artifactId" rev="$version" />
''';
      case DependencyChoices.grape:
        return """
@Grapes(
  @Grab(group='$groupId', module='$artifactId', version='$version')
)
""";
      case DependencyChoices.lein:
        return '''
[$groupId/$artifactId "$version"]
''';
      case DependencyChoices.buildr:
        return """
'$groupId:$artifactId:jar:$version'
""";
      case DependencyChoices.central:
        //TODO: version? - https://shields.io/category/version
        return '''
[![Maven Central](https://img.shields.io/maven-central/v/$groupId/$artifactId.svg?label=Maven%20Central)](https://search.maven.org/search?q=g:%22$groupId%22%20AND%20a:%22$artifactId%22)
''';
      case DependencyChoices.purl:
        return '''
pkg:maven/$groupId/$artifactId@$version
''';
      case DependencyChoices.bazel:
        return '''
maven_jar(
    name = "$artifactId",
    artifact = "$groupId:$artifactId:$version",
    sha1 = "abc123def456ghi789",
)
'''; //TODO: get checksum...
      default:
        return 'ERROR: Unrecognized dependency format.';
    }
  }
}
