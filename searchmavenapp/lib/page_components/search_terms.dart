//https://flutter.io/docs/cookbook/navigation/passing-data
//passing with plain old Strings didn't work
class SearchTerms {
  static const String searchTypeQuick = 'Quick';
  static const String searchTypeAdvanced = 'Advanced';
  static const String searchTypeVersion = 'Version';

  //"Quick" or "Advanced" - TODO: classname, group, artifact, all versions
  //     GroupId
  //     ArtifactId
  //     All Versions
  // -> To App Bar Title & adjust Context Menu for the given search (i.e. hide that search, and show the others)
  final String searchType;

  final String quickSearch;

  final String groupId;
  final String artifactId;
  final String version;
  final String packaging;
  final String classifier;

  final String classname;

  SearchTerms({
    required this.searchType,
    this.quickSearch = '',
    this.groupId = '',
    this.artifactId = '',
    this.version = '',
    this.packaging = '',
    this.classifier = '',
    this.classname = '',
  });

  bool isQuickSearch() {
    return searchTypeQuick == searchType;
  }

  bool isVersionSearch() {
    return searchTypeVersion == searchType;
  }

  @override
  String toString() {
    if (isQuickSearch()) {
      return "$searchType Search Terms - $quickSearch";
    } else if ("Advanced" == searchType) {
      return "$searchType Search Terms - $groupId:$artifactId:$version:$packaging:$classifier";
    } else if ("Classname" == searchType) {
      return "$searchType Search Terms - $classname";
    } else {
      return "Other Search: $searchType";
    }
  }
}
