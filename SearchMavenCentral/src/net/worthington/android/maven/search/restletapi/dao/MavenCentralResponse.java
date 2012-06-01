package net.worthington.android.maven.search.restletapi.dao;

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
