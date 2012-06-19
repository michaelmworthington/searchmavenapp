package net.worthington.android.maven.search.restletapi;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.restletapi.dao.MCRDoc;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import net.worthington.android.maven.search.restletapi.dao.MavenCentralResponse;

import org.joda.time.DateTime;
import org.restlet.Client;
import org.restlet.Context;
import org.restlet.data.Protocol;
import org.restlet.engine.Engine;
import org.restlet.ext.jackson.JacksonConverter;
import org.restlet.resource.ClientResource;
import org.restlet.resource.ResourceException;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.util.Log;

public class MavenCentralRestAPI
{
  private boolean iDemoMode = false;
  private int iNumResults = 20;
  
  public MavenCentralRestAPI(android.content.Context pContext)
  {
    SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(pContext);
    iDemoMode = settings.getBoolean("demoMode", false);
    iNumResults = Integer.valueOf(settings.getString("numResults", null));
  }

  /**
   * Perform a basic term search
   * 
   * @param pTerm
   */
  public MCRResponse searchBasic(String pTerm)
  {
    String quickSearch = "q=" + pTerm;

    Log.d(Constants.LOG_TAG, "Making a REST Call to Maven Central Search for term: " + pTerm + "...");
    return search(quickSearch);
  }

  public MCRResponse searchForAllVersions(String pGroupId, String pArtifactId)
  {
    String allVersionsSearch = "q=g:\"" + pGroupId + "\"+AND+a:\"" + pArtifactId + "\"&core=gav";

    Log.d(Constants.LOG_TAG, "Making a REST Call to Maven Central Search for term: " + allVersionsSearch + "...");
    return search(allVersionsSearch);
  }

  public MCRResponse searchChecksum(String pChecksum)
  {
    String checksumSearch = "q=1:\"" + pChecksum + "\"";

    Log.d(Constants.LOG_TAG, "Making a REST Call to Maven Central Search for checksum: " + pChecksum + "...");
    return search(checksumSearch);
  }

  /**
   * Perform an AND search based on the passed in coordinates
   * 
   * Filters out the fields that have the exact term "Search" in it since that's the default value for the text fields
   * 
   * @param pGroupId
   * @param pArtifactId
   * @param pVersion
   * @param pPackaging
   * @param pClassifier
   * @return
   */
  public MCRResponse searchCoordinate(String pGroupId, String pArtifactId, String pVersion, String pPackaging,
      String pClassifier)
  {
    String advancedANDSearch = "q=";
    boolean firstTermComplete = false;
    String groupIdTerm;
    String artifactIdTerm;
    String versionTerm;
    String classifierTerm;
    String packagingTerm;

    if ("Search".equals(pGroupId) == false)
    {
      groupIdTerm = "g:\"" + pGroupId + "\"";
      advancedANDSearch = appendTerm(advancedANDSearch, groupIdTerm, firstTermComplete);
      firstTermComplete = true;
    }

    if ("Search".equals(pArtifactId) == false)
    {
      artifactIdTerm = "a:\"" + pArtifactId + "\"";
      advancedANDSearch = appendTerm(advancedANDSearch, artifactIdTerm, firstTermComplete);
      firstTermComplete = true;
    }

    if ("Search".equals(pVersion) == false)
    {
      versionTerm = "v:\"" + pVersion + "\"";
      advancedANDSearch = appendTerm(advancedANDSearch, versionTerm, firstTermComplete);
      firstTermComplete = true;
    }

    if ("Search".equals(pClassifier) == false)
    {
      classifierTerm = "l:\"" + pClassifier + "\"";
      advancedANDSearch = appendTerm(advancedANDSearch, classifierTerm, firstTermComplete);
      firstTermComplete = true;
    }

    if ("Search".equals(pPackaging) == false)
    {
      packagingTerm = "p:\"" + pPackaging + "\"";
      advancedANDSearch = appendTerm(advancedANDSearch, packagingTerm, firstTermComplete);
      firstTermComplete = true;
    }

    Log.d(Constants.LOG_TAG, "Making a REST Call to Maven Central Search for term: " + advancedANDSearch + "...");
    return search(advancedANDSearch);
  }

  /**
   * Search for either a base class name or a fully qualified class name
   * 
   * assume that a search term with dots is fully qualified need to use "fc" instead of "c"
   * 
   * @param pClassName
   * @return
   */
  public MCRResponse searchClassName(String pClassName)
  {
    String classNameQueryString = "q=";
    // TODO: debug - is this actually a dot or any character
    if (pClassName.contains("."))
    {
      classNameQueryString += "f";
    }

    classNameQueryString += "c:\"" + pClassName + "\"";

    Log.d(Constants.LOG_TAG, "Making a REST Call to Maven Central Search for classname: " + pClassName + "...");
    return search(classNameQueryString);
  }

  private String appendTerm(String pAdvancedANDSearch, String pTerm, boolean pFirstTermComplete)
  {
    String returnValue = pAdvancedANDSearch;
    String andTerm = "%20AND%20";

    if (pFirstTermComplete)
    {
      returnValue += andTerm;
    }

    returnValue += pTerm;

    return returnValue;
  }

  /**
   * Builds up the REST URL and makes a call with the RESTLET API and returns the MCRResponse POJO
   * 
   * @param pSearchQueryString
   *          the part of the query string according to the search.maven.org API. <b>must start with "q="</b>
   * @return
   */
  private MCRResponse search(String pSearchQueryString)
  {
    MCRResponse returnValue = null;

    if (iDemoMode)
    {
      MCRDoc doc = new MCRDoc();
      doc.setId("log4j:log4j");
      doc.setG("log4j");
      doc.setA("log4j");
      doc.setLatestVersion("1.2.17");
      doc.setRepositoryId("central");
      doc.setP("bundle");
      doc.setTimestamp(new DateTime(1338025419000L));
      doc.setVersionCount(14);
      doc.setText(Arrays.asList("log4j", "log4j", "-sources.jar", "-javadoc.jar", ".jar", ".zip", ".tar.gz", "pom"));
      doc.setEc(Arrays.asList("-sources.jar", "-javadoc.jar", ".jar", ".zip", ".tar.gz", "pom"));
      
      List<MCRDoc> docs = new ArrayList<MCRDoc>();
      docs.add(doc);
      
      returnValue = new MCRResponse();
      returnValue.setNumFound(1);
      returnValue.setStart(0);
      returnValue.setDocs(docs);
    }
    
    if (returnValue == null && pSearchQueryString != null && pSearchQueryString.startsWith("q="))
    {

      initializeRestlet();

      String baseUrl = "http://search.maven.org/solrsearch/select?";
      String numResults = "rows=" + iNumResults;
      String startPosition = "start=0";
      String resultsFormat = "wt=json";

      String url = baseUrl + numResults + "&" + startPosition + "&" + resultsFormat + "&" + pSearchQueryString;

      Client client = new Client(new Context(), Protocol.HTTP);
      ClientResource res = new ClientResource(url);
      res.setNext(client);

      try
      {
        MavenCentralResponse rep = res.get(MavenCentralResponse.class);
        returnValue = rep.getResponse();

        int code = res.getStatus().getCode();
        String description = res.getStatus().getDescription();
        Log.d(Constants.LOG_TAG, String.format("GET %s: Response %s-%s: %s%n", url, code, description, rep.toString()));
      }
      catch (ResourceException ex)
      {
        int code = ex.getStatus().getCode();
        String description = ex.getStatus().getDescription();
        // TODO: display error message to user
        Log.d(Constants.LOG_TAG, String.format("GET %s: Response %s: %s%n", url, code, description));
      }
      catch (Exception ex)
      {
        // TODO: display error message to user
        Log.d(Constants.LOG_TAG, "REST Call Failed: " + ex.getMessage(), ex);
      }
    }
    else
    {
      throw new IllegalArgumentException("Maven Central Search Query String is missing or does not start with \"q=\"");
    }

    return returnValue;
  }

  /**
   * Need to do this since RESTLET doesn't get initialized properly on Android
   * 
   * @see http://wiki.restlet.org/docs_2.0/13-restlet/275-restlet/266-restlet.html
   */
  private void initializeRestlet()
  {
    Engine.getInstance().getRegisteredConverters().add(new JacksonConverter());
  }

}
