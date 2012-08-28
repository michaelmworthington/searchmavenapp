package net.worthington.android.maven.search.restletapi.dao;

import java.io.Serializable;
import java.util.List;

public class MCRResponse implements Serializable
{
  private static final long serialVersionUID = 1L;
  
  private int          iNumFound;
  private int          iStart;
  private List<MCRDoc> iDocs;
  private String iSearchString;

  public int getNumFound()
  {
    return iNumFound;
  }

  public void setNumFound(int pNumFound)
  {
    iNumFound = pNumFound;
  }

  public int getStart()
  {
    return iStart;
  }

  public void setStart(int pStart)
  {
    iStart = pStart;
  }

  public List<MCRDoc> getDocs()
  {
    return iDocs;
  }

  public void setDocs(List<MCRDoc> pDocs)
  {
    iDocs = pDocs;
  }

  public String getSearchString()
  {
    return iSearchString;
  }

  public void setSearchString(String pSearchQueryString)
  {
    iSearchString = pSearchQueryString;
  }
}
