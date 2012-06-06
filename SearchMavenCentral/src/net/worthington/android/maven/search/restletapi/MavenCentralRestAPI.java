package net.worthington.android.maven.search.restletapi;

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
   * Makes a REST Call to Search Maven Central
   * 
   * @param pTerm
   */
  public MCRResponse search(String pTerm)
  {
    initializeRestlet();

    String numResults = "20";
    String startPosition = "0";
    String url = "http://search.maven.org/solrsearch/select?rows=" + numResults + "&start=" + startPosition
        + "&wt=json&q=" + pTerm;

    MCRResponse returnValue = null;

    Log.d("net.worthington", "Making a REST Call to Maven Central Search for term: " + pTerm + "...");

    Client client = new Client(new Context(), Protocol.HTTP);
    ClientResource res = new ClientResource(url);
    res.setNext(client);

    try
    {
      MavenCentralResponse rep = res.get(MavenCentralResponse.class);
      returnValue = rep.getResponse();

      int code = res.getStatus().getCode();
      String description = res.getStatus().getDescription();
      Log.d("net.worthington", String.format("GET %s: Response %s-%s: %s%n", url, code, description, rep.toString()));
    }
    catch (ResourceException ex)
    {
      int code = ex.getStatus().getCode();
      String description = ex.getStatus().getDescription();
      Log.d("net.worthington", String.format("GET %s: Response %s: %s%n", url, code, description));
    }
    catch (Exception ex)
    {
      Log.d("net.worthington", "REST Call Failed: " + ex.getMessage(), ex);
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
