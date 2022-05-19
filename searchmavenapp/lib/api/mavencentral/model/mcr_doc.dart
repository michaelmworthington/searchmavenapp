//from: ./src/com/searchmavenapp/android/maven/search/restletapi/dao/MCRDoc.java
class MCRDoc {
  final String? iId;
  final String? iG;
  final String? iA;
  final String? iV;
  final String? iLatestVersion;
  final String? iRepositoryId;
  final String? iP;
  final int? iTimestamp;
  final int? iVersionCount;
  final List<String>? iText;
  final List<String>? iTags;
  final List<String>? iEc;

  MCRDoc({
    this.iId,
    this.iG,
    this.iA,
    this.iV,
    this.iLatestVersion,
    this.iRepositoryId,
    this.iP,
    this.iTimestamp,
    this.iVersionCount,
    this.iText,
    this.iTags,
    this.iEc,
  });

  factory MCRDoc.fromJson(Map<String, dynamic> json) {
    return MCRDoc(
      iId: json['id'],
      iG: json['g'],
      iA: json['a'],
      iV: json['v'],
      iLatestVersion: json['latestVersion'],
      iRepositoryId: json['repositoryId'],
      iP: json['p'],
      iTimestamp: json['timestamp'],
      iVersionCount: json['versionCount'],
      iText: json['text']?.cast<String>(),
      iTags: json['tags']?.cast<String>(),
      iEc: json['ec']?.cast<String>(),
    );
  }
}
