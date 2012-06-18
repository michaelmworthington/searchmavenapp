package net.worthington.android.maven.search.restletapi.dao;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;

//TODO: figure out how to parse highlighting
//http://wiki.fasterxml.com/JacksonFAQ#Deserializing:_unknown_properties
@JsonIgnoreProperties({ "highlighting" })
public class MavenCentralResponse
{
  private MCRResponseHeader iResponseHeader;
  private MCRResponse       iResponse;
  private MCRSpellCheck     iSpellcheck;

  public MCRResponseHeader getResponseHeader()
  {
    return iResponseHeader;
  }

  public void setResponseHeader(MCRResponseHeader responseHeader)
  {
    iResponseHeader = responseHeader;
  }

  public MCRResponse getResponse()
  {
    return iResponse;
  }

  public void setResponse(MCRResponse response)
  {
    iResponse = response;
  }

  public MCRSpellCheck getSpellcheck()
  {
    return iSpellcheck;
  }

  public void setSpellcheck(MCRSpellCheck spellcheck)
  {
    iSpellcheck = spellcheck;
  }
}
