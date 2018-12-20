import 'package:flutter/material.dart';
//import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CentralSearchAPI {

  //See MavenCentralRestAPI.java
  Future<MavenCentralResponse> search({String pSearchQueryString, int pStart, bool pDemoMode}) async {
    int _numResults = 20;

    String baseUrl = "http://search.maven.org/solrsearch/select?";
    String numResults = "rows=" + _numResults.toString();
    String startPosition = "start=" + pStart.toString();
    String resultsFormat = "wt=json";

    String url = baseUrl + numResults + "&" + startPosition + "&" + resultsFormat + "&" + pSearchQueryString;
    
    if(pDemoMode == null || pDemoMode){
      debugPrint("DEMO MODE SEARCH RESPONSE");
      return MavenCentralResponse.fromJson(json.decode(testResponse));
    }
    else {
      return await _performHttpGet(url);
    }
  }

  Future<MavenCentralResponse> _performHttpGet(String url) async {
    debugPrint("Searching Central: $url");

    //https://flutter.io/docs/cookbook/networking/fetch-data
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      debugPrint(response.body);
    
      //Supplemental parsing json w/ dart: https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
      return MavenCentralResponse.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load MavenCentralResponse');
    }
  }
}

//from: ./src/com/searchmavenapp/android/maven/search/restletapi/dao/MavenCentralResponse.java
class MavenCentralResponse {
  final Map responseHeader;
  final MCRResponse response;
  final Map spellcheck;

  MavenCentralResponse({this.responseHeader, this.response, this.spellcheck});

  factory MavenCentralResponse.fromJson(Map<String, dynamic> json) {
    return MavenCentralResponse(
      responseHeader: json['responseHeader'],
      response: MCRResponse.fromJson(json['response']),
      spellcheck: json['spellcheck'],
    );
  }
}

//from: ./src/com/searchmavenapp/android/maven/search/restletapi/dao/MCRResponse.java
class MCRResponse {
  final int numFound;
  final int start;
  final List<MCRDoc> docs;
  //TODO: searchString
  
  MCRResponse({this.numFound, this.start, this.docs});

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
  
//from: ./src/com/searchmavenapp/android/maven/search/restletapi/dao/MCRDoc.java
class MCRDoc {
  final String            iId;
  final String            iG;
  final String            iA;
  final String            iV;
  final String            iLatestVersion;
  final String            iRepositoryId;
  final String            iP;
  final int               iTimestamp;
  final int               iVersionCount;
  final List<String>      iText;
  final List<String>      iTags;
  final List<String>      iEc;

  MCRDoc({this.iId, this.iG, this.iA, this.iV, this.iLatestVersion, this.iRepositoryId, this.iP, this.iTimestamp, this.iVersionCount, this.iText, this.iTags, this.iEc});

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

String testResponse = '{"responseHeader":{"status":0,"QTime":0,"params":{"q":"log4j","defType":"dismax","spellcheck":"true","qf":"text^20 g^5 a^10","indent":"off","fl":"id,g,a,latestVersion,p,ec,repositoryId,text,timestamp,versionCount","start":"0","spellcheck.count":"5","sort":"score desc,timestamp desc,g asc,a asc","rows":"20","wt":"json","version":"2.2"}},"response":{"numFound":463,"start":0,"docs":[{"id":"com.opsbears.webcomponents.application.slf4j:log4j","g":"com.opsbears.webcomponents.application.slf4j","a":"log4j","latestVersion":"1.0.0-alpha13","repositoryId":"central","p":"jar","timestamp":1538215270000,"versionCount":4,"text":["com.opsbears.webcomponents.application.slf4j","log4j","-sources.jar","-javadoc.jar",".jar",".pom"],"ec":["-sources.jar","-javadoc.jar",".jar",".pom"]},{"id":"at.willhaben.willtest:log4j","g":"at.willhaben.willtest","a":"log4j","latestVersion":"1.3.0","repositoryId":"central","p":"jar","timestamp":1537344425000,"versionCount":21,"text":["at.willhaben.willtest","log4j","-javadoc.jar","-sources.jar",".jar",".pom"],"ec":["-javadoc.jar","-sources.jar",".jar",".pom"]},{"id":"org.apache.logging.log4j:log4j","g":"org.apache.logging.log4j","a":"log4j","latestVersion":"2.11.1","repositoryId":"central","p":"pom","timestamp":1532317448000,"versionCount":34,"text":["org.apache.logging.log4j","log4j","-site.xml",".pom"],"ec":["-site.xml",".pom"]},{"id":"org.wso2.carbon.analytics.shared:log4j","g":"org.wso2.carbon.analytics.shared","a":"log4j","latestVersion":"1.0.4","repositoryId":"central","p":"pom","timestamp":1520509292000,"versionCount":1,"text":["org.wso2.carbon.analytics.shared","log4j",".pom"],"ec":[".pom"]},{"id":"org.darkphoenixs:log4j","g":"org.darkphoenixs","a":"log4j","latestVersion":"1.3.5","repositoryId":"central","p":"bundle","timestamp":1505926292000,"versionCount":7,"text":["org.darkphoenixs","log4j","-sources.jar","-javadoc.jar",".jar",".pom"],"ec":["-sources.jar","-javadoc.jar",".jar",".pom"]},{"id":"com.att.inno:log4j","g":"com.att.inno","a":"log4j","latestVersion":"1.2.13","repositoryId":"central","p":"jar","timestamp":1499634881000,"versionCount":2,"text":["com.att.inno","log4j","-sources.jar","-javadoc.jar",".jar",".pom"],"ec":["-sources.jar","-javadoc.jar",".jar",".pom"]},{"id":"uk.co.nichesolutions.logging.log4j:log4j","g":"uk.co.nichesolutions.logging.log4j","a":"log4j","latestVersion":"2.6.3-CUSTOM","repositoryId":"central","p":"pom","timestamp":1491401062000,"versionCount":1,"text":["uk.co.nichesolutions.logging.log4j","log4j","-source-release.zip",".pom"],"ec":["-source-release.zip",".pom"]},{"id":"com.jkoolcloud.tnt4j.logger:log4j","g":"com.jkoolcloud.tnt4j.logger","a":"log4j","latestVersion":"0.1","repositoryId":"central","p":"jar","timestamp":1465505785000,"versionCount":1,"text":["com.jkoolcloud.tnt4j.logger","log4j","-javadoc.jar","-sources.jar",".jar","-log4j-0.1-deploy.zip",".pom"],"ec":["-javadoc.jar","-sources.jar",".jar","-log4j-0.1-deploy.zip",".pom"]},{"id":"log4j:log4j","g":"log4j","a":"log4j","latestVersion":"1.2.17","repositoryId":"central","p":"bundle","timestamp":1338025419000,"versionCount":14,"text":["log4j","log4j","-javadoc.jar","-sources.jar",".jar",".zip",".tar.gz",".pom"],"ec":["-javadoc.jar","-sources.jar",".jar",".zip",".tar.gz",".pom"]},{"id":"de.huxhorn.lilith:log4j","g":"de.huxhorn.lilith","a":"log4j","latestVersion":"0.9.41","repositoryId":"central","p":"jar","timestamp":1304365019000,"versionCount":2,"text":["de.huxhorn.lilith","log4j","-sources.jar","-javadoc.jar",".jar",".pom"],"ec":["-sources.jar","-javadoc.jar",".jar",".pom"]},{"id":"org.mod4j.org.eclipse.xtext:log4j","g":"org.mod4j.org.eclipse.xtext","a":"log4j","latestVersion":"1.2.15","repositoryId":"central","p":"jar","timestamp":1250247760000,"versionCount":1,"text":["org.mod4j.org.eclipse.xtext","log4j",".jar",".pom"],"ec":[".jar",".pom"]},{"id":"com.vlkan.log4j2:log4j2-logstash-layout-parent","g":"com.vlkan.log4j2","a":"log4j2-logstash-layout-parent","latestVersion":"0.15","repositoryId":"central","p":"pom","timestamp":1542984898000,"versionCount":15,"text":["com.vlkan.log4j2","log4j2-logstash-layout-parent",".pom"],"ec":[".pom"]},{"id":"me.yoram.log4j-infra:log4j-infra","g":"me.yoram.log4j-infra","a":"log4j-infra","latestVersion":"0.2.2","repositoryId":"central","p":"pom","timestamp":1537049891000,"versionCount":2,"text":["me.yoram.log4j-infra","log4j-infra",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-bom","g":"org.apache.logging.log4j","a":"log4j-bom","latestVersion":"2.11.1","repositoryId":"central","p":"pom","timestamp":1532317770000,"versionCount":22,"text":["org.apache.logging.log4j","log4j-bom",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-audit","g":"org.apache.logging.log4j","a":"log4j-audit","latestVersion":"1.0.0","repositoryId":"central","p":"pom","timestamp":1528664530000,"versionCount":1,"text":["org.apache.logging.log4j","log4j-audit",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-catalog","g":"org.apache.logging.log4j","a":"log4j-catalog","latestVersion":"1.0.0","repositoryId":"central","p":"pom","timestamp":1528664430000,"versionCount":1,"text":["org.apache.logging.log4j","log4j-catalog",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-audit-parent","g":"org.apache.logging.log4j","a":"log4j-audit-parent","latestVersion":"1.0.0","repositoryId":"central","p":"pom","timestamp":1528664428000,"versionCount":1,"text":["org.apache.logging.log4j","log4j-audit-parent",".pom"],"ec":[".pom"]},{"id":"com.vlkan.log4j2:log4j2-redis-appender-parent","g":"com.vlkan.log4j2","a":"log4j2-redis-appender-parent","latestVersion":"0.4","repositoryId":"central","p":"pom","timestamp":1508001332000,"versionCount":4,"text":["com.vlkan.log4j2","log4j2-redis-appender-parent",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-core-its","g":"org.apache.logging.log4j","a":"log4j-core-its","latestVersion":"2.8.2","repositoryId":"central","p":"pom","timestamp":1491165469000,"versionCount":1,"text":["org.apache.logging.log4j","log4j-core-its",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j.samples:log4j-samples","g":"org.apache.logging.log4j.samples","a":"log4j-samples","latestVersion":"2.0.1","repositoryId":"central","p":"pom","timestamp":1406682020000,"versionCount":4,"text":["org.apache.logging.log4j.samples","log4j-samples",".pom"],"ec":[".pom"]}]},"spellcheck":{"suggestions":[]}}';