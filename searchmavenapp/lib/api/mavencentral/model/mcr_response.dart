import 'mcr_doc.dart';

//from: ./src/com/searchmavenapp/android/maven/search/restletapi/dao/MCRResponse.java
class MCRResponse {
  final int numFound;
  final int start;
  final List<MCRDoc> docs;
  //TODO: searchString

  MCRResponse({
    required this.numFound,
    required this.start,
    required this.docs,
  });

  factory MCRResponse.fromJson(Map<String, dynamic> json) {
    var docsJson = json['docs'] as List;
    List<MCRDoc> docsList = docsJson.map((i) => MCRDoc.fromJson(i)).toList();

    return MCRResponse(
      numFound: json['numFound'],
      start: json['start'],
      docs: docsList,
    );
  }
}
