import 'package:flutter/material.dart';
//import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../page_components/search_terms.dart';
import 'model/mavencentralresponse.dart';

class CentralSearchAPI {
  //See MavenCentralRestAPI.java & ProgressThread.java
  Future<MavenCentralResponse> search({
    required SearchTerms pSearchTerms,
    required BuildContext pContext,
    int pNumResults = 20,
    int pStart = 0,
    bool pDemoMode = false,
  }) async {
    String queryTerm = _formatQueryParam(pSearchTerms);

    Uri myUri = Uri(
      scheme: 'https',
      host: 'search.maven.org',
      // host: 'c1bcc446-5b66-4991-985d-ae7b82a26913.mock.pstmn.io',
      path: '/solrsearch/select/',
      queryParameters: {
        'rows': pNumResults.toString(),
        'start': pStart.toString(),
        'wt': 'json',
        'q': queryTerm
      },
    );

    if (pDemoMode) {
      debugPrint("DEMO MODE SEARCH RESPONSE");

      await Future.delayed(const Duration(seconds: 3));

      final data = await DefaultAssetBundle.of(pContext)
          .loadString('assets/model/mavencentralresponse.json');

      final body = json.decode(data);
      // final body = json.decode(testResponse);

      return MavenCentralResponse.fromJson(body);
    } else {
      return await _performHttpGet(myUri);
    }
  }

  Future<MavenCentralResponse> _performHttpGet(Uri url) async {
    debugPrint("Searching Central: $url");

    //https://flutter.io/docs/cookbook/networking/fetch-data
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      //Supplemental parsing json w/ dart: https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
      MavenCentralResponse mcr =
          MavenCentralResponse.fromJson(json.decode(response.body));

      debugPrint(
          'Response Code: ${response.statusCode} - Num Results: ${mcr.response.docs.length} - Total Results: ${mcr.response.numFound}');
      //debugPrint(response.body);

      return mcr;
    } else {
      // If that response was not OK, throw an error.
      throw Exception(
          'Failed to load MavenCentralResponse: HTTP Response != 200: was ${response.statusCode}');
    }
  }

  String _formatQueryParam(SearchTerms pSearchTerms) {
    String returnValue = "";

    if (pSearchTerms.isQuickSearch()) {
      returnValue = pSearchTerms.quickSearch;
    } else {
      if (pSearchTerms.classname != '') {
        returnValue = _formatClassNameSearchQueryParam(pSearchTerms);
      } else {
        returnValue = _formatCoordinateSearchQueryParam(pSearchTerms);
      }
    }

    return returnValue;
  }

  // Search for either a base class name or a fully qualified class name
  // assume that a search term with dots is fully qualified need to use "fc" instead of "c"
  String _formatClassNameSearchQueryParam(SearchTerms pSearchTerms) {
    String returnValue = '';

    if (pSearchTerms.classname.contains('.')) {
      returnValue += 'f';
    }

    returnValue += 'c:"${pSearchTerms.classname}"';
    return returnValue;
  }

  String _formatCoordinateSearchQueryParam(SearchTerms pSearchTerms) {
    String returnValue = '';
    bool isFirstTermComplete = false;

    if (pSearchTerms.groupId != '') {
      returnValue +=
          _appendTerm(isFirstTermComplete, 'g:"${pSearchTerms.groupId}"');
      isFirstTermComplete = true;
    }

    if (pSearchTerms.artifactId != '') {
      returnValue +=
          _appendTerm(isFirstTermComplete, 'a:"${pSearchTerms.artifactId}"');
      isFirstTermComplete = true;
    }

    if (pSearchTerms.version != '') {
      returnValue +=
          _appendTerm(isFirstTermComplete, 'v:"${pSearchTerms.version}"');
      isFirstTermComplete = true;
    }

    if (pSearchTerms.classifier != '') {
      returnValue +=
          _appendTerm(isFirstTermComplete, 'l:"${pSearchTerms.classifier}"');
      isFirstTermComplete = true;
    }

    if (pSearchTerms.packaging != '') {
      returnValue +=
          _appendTerm(isFirstTermComplete, 'p:"${pSearchTerms.packaging}"');
      isFirstTermComplete = true;
    }

    return returnValue;
  }

  String _appendTerm(bool isFirstTermComplete, String pTerm) {
    String returnValue = '';
    // String andTerm = "%20AND%20";
    // Flutter will do the escaping for us
    String andTerm = " AND ";

    if (isFirstTermComplete) {
      returnValue += andTerm;
    }

    returnValue += pTerm;

    return returnValue;
  }
}

//String testResponse =
//    '{"responseHeader":{"status":0,"QTime":0,"params":{"q":"log4j","defType":"dismax","spellcheck":"true","qf":"text^20 g^5 a^10","indent":"off","fl":"id,g,a,latestVersion,p,ec,repositoryId,text,timestamp,versionCount","start":"0","spellcheck.count":"5","sort":"score desc,timestamp desc,g asc,a asc","rows":"20","wt":"json","version":"2.2"}},"response":{"numFound":463,"start":0,"docs":[{"id":"com.opsbears.webcomponents.application.slf4j:log4j","g":"com.opsbears.webcomponents.application.slf4j","a":"log4j","latestVersion":"1.0.0-alpha13","repositoryId":"central","p":"jar","timestamp":1538215270000,"versionCount":4,"text":["com.opsbears.webcomponents.application.slf4j","log4j","-sources.jar","-javadoc.jar",".jar",".pom"],"ec":["-sources.jar","-javadoc.jar",".jar",".pom"]},{"id":"at.willhaben.willtest:log4j","g":"at.willhaben.willtest","a":"log4j","latestVersion":"1.3.0","repositoryId":"central","p":"jar","timestamp":1537344425000,"versionCount":21,"text":["at.willhaben.willtest","log4j","-javadoc.jar","-sources.jar",".jar",".pom"],"ec":["-javadoc.jar","-sources.jar",".jar",".pom"]},{"id":"org.apache.logging.log4j:log4j","g":"org.apache.logging.log4j","a":"log4j","latestVersion":"2.11.1","repositoryId":"central","p":"pom","timestamp":1532317448000,"versionCount":34,"text":["org.apache.logging.log4j","log4j","-site.xml",".pom"],"ec":["-site.xml",".pom"]},{"id":"org.wso2.carbon.analytics.shared:log4j","g":"org.wso2.carbon.analytics.shared","a":"log4j","latestVersion":"1.0.4","repositoryId":"central","p":"pom","timestamp":1520509292000,"versionCount":1,"text":["org.wso2.carbon.analytics.shared","log4j",".pom"],"ec":[".pom"]},{"id":"org.darkphoenixs:log4j","g":"org.darkphoenixs","a":"log4j","latestVersion":"1.3.5","repositoryId":"central","p":"bundle","timestamp":1505926292000,"versionCount":7,"text":["org.darkphoenixs","log4j","-sources.jar","-javadoc.jar",".jar",".pom"],"ec":["-sources.jar","-javadoc.jar",".jar",".pom"]},{"id":"com.att.inno:log4j","g":"com.att.inno","a":"log4j","latestVersion":"1.2.13","repositoryId":"central","p":"jar","timestamp":1499634881000,"versionCount":2,"text":["com.att.inno","log4j","-sources.jar","-javadoc.jar",".jar",".pom"],"ec":["-sources.jar","-javadoc.jar",".jar",".pom"]},{"id":"uk.co.nichesolutions.logging.log4j:log4j","g":"uk.co.nichesolutions.logging.log4j","a":"log4j","latestVersion":"2.6.3-CUSTOM","repositoryId":"central","p":"pom","timestamp":1491401062000,"versionCount":1,"text":["uk.co.nichesolutions.logging.log4j","log4j","-source-release.zip",".pom"],"ec":["-source-release.zip",".pom"]},{"id":"com.jkoolcloud.tnt4j.logger:log4j","g":"com.jkoolcloud.tnt4j.logger","a":"log4j","latestVersion":"0.1","repositoryId":"central","p":"jar","timestamp":1465505785000,"versionCount":1,"text":["com.jkoolcloud.tnt4j.logger","log4j","-javadoc.jar","-sources.jar",".jar","-log4j-0.1-deploy.zip",".pom"],"ec":["-javadoc.jar","-sources.jar",".jar","-log4j-0.1-deploy.zip",".pom"]},{"id":"log4j:log4j","g":"log4j","a":"log4j","latestVersion":"1.2.17","repositoryId":"central","p":"bundle","timestamp":1338025419000,"versionCount":14,"text":["log4j","log4j","-javadoc.jar","-sources.jar",".jar",".zip",".tar.gz",".pom"],"ec":["-javadoc.jar","-sources.jar",".jar",".zip",".tar.gz",".pom"]},{"id":"de.huxhorn.lilith:log4j","g":"de.huxhorn.lilith","a":"log4j","latestVersion":"0.9.41","repositoryId":"central","p":"jar","timestamp":1304365019000,"versionCount":2,"text":["de.huxhorn.lilith","log4j","-sources.jar","-javadoc.jar",".jar",".pom"],"ec":["-sources.jar","-javadoc.jar",".jar",".pom"]},{"id":"org.mod4j.org.eclipse.xtext:log4j","g":"org.mod4j.org.eclipse.xtext","a":"log4j","latestVersion":"1.2.15","repositoryId":"central","p":"jar","timestamp":1250247760000,"versionCount":1,"text":["org.mod4j.org.eclipse.xtext","log4j",".jar",".pom"],"ec":[".jar",".pom"]},{"id":"com.vlkan.log4j2:log4j2-logstash-layout-parent","g":"com.vlkan.log4j2","a":"log4j2-logstash-layout-parent","latestVersion":"0.15","repositoryId":"central","p":"pom","timestamp":1542984898000,"versionCount":15,"text":["com.vlkan.log4j2","log4j2-logstash-layout-parent",".pom"],"ec":[".pom"]},{"id":"me.yoram.log4j-infra:log4j-infra","g":"me.yoram.log4j-infra","a":"log4j-infra","latestVersion":"0.2.2","repositoryId":"central","p":"pom","timestamp":1537049891000,"versionCount":2,"text":["me.yoram.log4j-infra","log4j-infra",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-bom","g":"org.apache.logging.log4j","a":"log4j-bom","latestVersion":"2.11.1","repositoryId":"central","p":"pom","timestamp":1532317770000,"versionCount":22,"text":["org.apache.logging.log4j","log4j-bom",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-audit","g":"org.apache.logging.log4j","a":"log4j-audit","latestVersion":"1.0.0","repositoryId":"central","p":"pom","timestamp":1528664530000,"versionCount":1,"text":["org.apache.logging.log4j","log4j-audit",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-catalog","g":"org.apache.logging.log4j","a":"log4j-catalog","latestVersion":"1.0.0","repositoryId":"central","p":"pom","timestamp":1528664430000,"versionCount":1,"text":["org.apache.logging.log4j","log4j-catalog",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-audit-parent","g":"org.apache.logging.log4j","a":"log4j-audit-parent","latestVersion":"1.0.0","repositoryId":"central","p":"pom","timestamp":1528664428000,"versionCount":1,"text":["org.apache.logging.log4j","log4j-audit-parent",".pom"],"ec":[".pom"]},{"id":"com.vlkan.log4j2:log4j2-redis-appender-parent","g":"com.vlkan.log4j2","a":"log4j2-redis-appender-parent","latestVersion":"0.4","repositoryId":"central","p":"pom","timestamp":1508001332000,"versionCount":4,"text":["com.vlkan.log4j2","log4j2-redis-appender-parent",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j:log4j-core-its","g":"org.apache.logging.log4j","a":"log4j-core-its","latestVersion":"2.8.2","repositoryId":"central","p":"pom","timestamp":1491165469000,"versionCount":1,"text":["org.apache.logging.log4j","log4j-core-its",".pom"],"ec":[".pom"]},{"id":"org.apache.logging.log4j.samples:log4j-samples","g":"org.apache.logging.log4j.samples","a":"log4j-samples","latestVersion":"2.0.1","repositoryId":"central","p":"pom","timestamp":1406682020000,"versionCount":4,"text":["org.apache.logging.log4j.samples","log4j-samples",".pom"],"ec":[".pom"]}]},"spellcheck":{"suggestions":[]}}';
