package net.worthington.android.maven.search.restletapi;

import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import net.worthington.android.maven.search.restletapi.dao.MavenCentralResponse;

import org.restlet.Client;
import org.restlet.Context;
import org.restlet.data.Protocol;
import org.restlet.engine.Engine;
import org.restlet.ext.jackson.JacksonConverter;
import org.restlet.resource.ClientResource;
import org.restlet.resource.ResourceException;

import android.util.Log;

public class MavenCentralRestAPI
{

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

    if (pSearchQueryString != null && pSearchQueryString.startsWith("q="))
    {

      initializeRestlet();

      String baseUrl = "http://search.maven.org/solrsearch/select?";
      String numResults = "rows=20";
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
