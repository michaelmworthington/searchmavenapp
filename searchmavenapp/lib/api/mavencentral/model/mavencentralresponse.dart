import 'mcr_response.dart';

//from: ./src/com/searchmavenapp/android/maven/search/restletapi/dao/MavenCentralResponse.java
class MavenCentralResponse {
  final Map responseHeader;
  final MCRResponse response;
  final Map spellcheck;

  MavenCentralResponse({
    required this.responseHeader,
    required this.response,
    required this.spellcheck,
  });

  factory MavenCentralResponse.fromJson(Map<String, dynamic> json) =>
      MavenCentralResponse(
        responseHeader: json['responseHeader'],
        response: MCRResponse.fromJson(json['response']),
        spellcheck: json['spellcheck'],
      );
}
