package com.searchmavenapp.android.maven.search.restletapi.dao;

import java.io.Serializable;
import java.util.List;

import org.joda.time.DateTime;

public class MCRDoc implements Serializable
{
  private static final long serialVersionUID = 1L;

  private String            iId;
  private String            iG;
  private String            iA;
  private String            iV;
  private String            iLatestVersion;
  private String            iRepositoryId;
  private String            iP;
  private DateTime          iTimestamp;
  private int               iVersionCount;
  private List<String>      iText;
  private List<String>      iTags;
  private List<String>      iEc;

  public String getId()
  {
    return iId;
  }

  public void setId(String pId)
  {
    iId = pId;
  }

  public String getG()
  {
    return iG;
  }

  public void setG(String pG)
  {
    iG = pG;
  }

  public String getA()
  {
    return iA;
  }

  public void setA(String pA)
  {
    iA = pA;
  }

  public String getV()
  {
    return iV;
  }

  public void setV(String pV)
  {
    iV = pV;
  }

  public String getLatestVersion()
  {
    return iLatestVersion;
  }

  public void setLatestVersion(String pLatestVersion)
  {
    iLatestVersion = pLatestVersion;
  }

  public String getRepositoryId()
  {
    return iRepositoryId;
  }

  public void setRepositoryId(String pRepositoryId)
  {
    iRepositoryId = pRepositoryId;
  }

  public String getP()
  {
    return iP;
  }

  public void setP(String pP)
  {
    iP = pP;
  }

  public DateTime getTimestamp()
  {
    return iTimestamp;
  }

  public void setTimestamp(DateTime pTimestamp)
  {
    iTimestamp = pTimestamp;
  }

  public int getVersionCount()
  {
    return iVersionCount;
  }

  public void setVersionCount(int pVersionCount)
  {
    iVersionCount = pVersionCount;
  }

  public List<String> getText()
  {
    return iText;
  }

  public void setText(List<String> pText)
  {
    iText = pText;
  }

  public List<String> getTags()
  {
    return iTags;
  }

  public void setTags(List<String> pTags)
  {
    iTags = pTags;
  }

  public List<String> getEc()
  {
    return iEc;
  }

  public void setEc(List<String> pEc)
  {
    iEc = pEc;
  }

  public String getGAV()
  {
    return iG + ":" + iA + ":" + iV;
  }
}
