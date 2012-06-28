package net.worthington.android.maven.search.constants;

public interface Constants
{
  public static final String   LOG_TAG                           = "net.worthington";

  public static final int      PROGRESS_DIALOG_QUICK_SEARCH      = 0;
  public static final int      PROGRESS_DIALOG_ADVANCED_SEARCH   = 1;
  public static final int      PROGRESS_DIALOG_ARTIFACT_DETAILS  = 2;
  public static final int      PROGRESS_DIALOG_GROUPID_SEARCH    = 3;
  public static final int      PROGRESS_DIALOG_ARTIFACTID_SEARCH = 4;
  public static final int      PROGRESS_DIALOG_VERSION_SEARCH    = 5;
  public static final int      PROGRESS_DIALOG_POM_VIEW          = 6;

  public static final String   ARTIFACT                          = "artifact";
  public static final String   SEARCH_RESULTS                    = "searchResults";
  public static final String   SEARCH_TYPE                       = "searchType";
  public static final String   POM                               = "pom";

  public static final String   DEP_APACHE_MAVEN                  = "Apache Maven";
  public static final String   DEP_APACHE_BUILDR                 = "Apache Buildr";
  public static final String   DEP_APACHE_IVY                    = "Apache Ivy";
  public static final String   DEP_GROOVY_GRAPE                  = "Groovy Grape";
  public static final String   DEP_GRAILS                        = "Grails";
  public static final String   DEP_SCALA_SBT                     = "Scala SBT";

  public static final String[] DEPENDENCY_FORMATS                = new String[] { DEP_APACHE_MAVEN, DEP_APACHE_BUILDR,
      DEP_APACHE_IVY, DEP_GROOVY_GRAPE, DEP_GRAILS, DEP_SCALA_SBT };

}
