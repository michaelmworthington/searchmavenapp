/**
 * 
 */
package net.worthington.android.maven.search;

import net.worthington.android.maven.search.activities.Main;
import net.worthington.android.maven.search.activities.MainAdvancedSearch;
import net.worthington.android.maven.search.activities.RealSearchResults;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.restletapi.MavenCentralRestAPI;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import android.app.Activity;
import android.os.Handler;
import android.os.Message;
import android.widget.EditText;

/**
 * @author Michael
 * 
 */
public class ProgressThread extends Thread
{
  private Handler  iHandler;
  private Activity iActivity;
  private int      iSearchType;

  // todo: convert pSearchType to an ENUM
  public ProgressThread(Handler pHandler, Activity pActivity, int pSearchType)
  {
    iHandler = pHandler;
    iActivity = pActivity;
    iSearchType = pSearchType;
  }

  public void run()
  {
    Message msg = iHandler.obtainMessage();
    MavenCentralRestAPI mcr = new MavenCentralRestAPI(iActivity);

    switch (iSearchType)
    {
      case Constants.PROGRESS_DIALOG_QUICK_SEARCH:
      {
        MCRResponse searchResults = handleQuickSearch(mcr);

        msg.arg1 = Constants.PROGRESS_DIALOG_QUICK_SEARCH;
        msg.obj = searchResults;
        break;
      }
      case Constants.PROGRESS_DIALOG_ADVANCED_SEARCH:
      {
        MCRResponse searchResults = handleAdvancedSearch(mcr);

        msg.arg1 = Constants.PROGRESS_DIALOG_ADVANCED_SEARCH;
        msg.obj = searchResults;
        break;
      }
      case Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS:
      {
        /*
         * TextView groupTV = (TextView) iActivity.findViewById(R.id.groupIdTextView); TextView artifactTV = (TextView)
         * iActivity.findViewById(R.id.artifactIdTextView); TextView latestVersionTV = (TextView)
         * iActivity.findViewById(R.id.latestVersionTextView); TextView lastUpdateTV = (TextView)
         * iActivity.findViewById(R.id.lastUpdateTextView);
         */

        // TODO: pass along the actual artifact details

        msg.arg1 = Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS;
        break;
      }
      case Constants.PROGRESS_DIALOG_GROUPID_SEARCH:
      {
        MCRResponse searchResults = handleGroupIdSearch(mcr);

        msg.arg1 = Constants.PROGRESS_DIALOG_GROUPID_SEARCH;
        msg.obj = searchResults;
        break;
      }
      case Constants.PROGRESS_DIALOG_ARTIFACTID_SEARCH:
      {
        MCRResponse searchResults = handleArtifactIdSearch(mcr);

        msg.arg1 = Constants.PROGRESS_DIALOG_ARTIFACTID_SEARCH;
        msg.obj = searchResults;
        break;
      }
      case Constants.PROGRESS_DIALOG_VERSION_SEARCH:
      {
        RealSearchResults rsr = (RealSearchResults) iActivity;
        Integer selectedVersionCount = rsr.getSelectedVersionCount();

        if (selectedVersionCount > 1)
        {
          MCRResponse searchResults = handleVersionSearch(mcr, rsr);

          msg.arg1 = Constants.PROGRESS_DIALOG_VERSION_SEARCH;
          msg.obj = searchResults;
        }
        else
        {
          // TODO: pass along the actual artifact details

          msg.arg1 = Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS;
        }
        break;
      }
      default:
        // TODO: bad search type, throw runtime exception, i think?
        break;
    }

    iHandler.sendMessage(msg);
  }

  private MCRResponse handleQuickSearch(MavenCentralRestAPI pMcr)
  {
    Main m = (Main) iActivity;
    EditText et = m.getSearchEditText();

    MCRResponse searchResults = pMcr.searchBasic(et.getText().toString().trim());
    return searchResults;
  }

  private MCRResponse handleAdvancedSearch(MavenCentralRestAPI pMcr)
  {
    MainAdvancedSearch mas = (MainAdvancedSearch) iActivity;

    String groupId = mas.getGroupIdSearchText().getText().toString().trim();
    String artifactId = mas.getArtifactIdSearchText().getText().toString().trim();
    String version = mas.getVersionSearchText().getText().toString().trim();
    String packaging = mas.getPackagingSearchText().getText().toString().trim();
    String classifier = mas.getClassifierSearchText().getText().toString().trim();
    String className = mas.getClassNameSearchText().getText().toString().trim();

    MCRResponse searchResults = null;
    if ("Search".equals(className) || className.trim().length() == 0)
    {
      searchResults = pMcr.searchCoordinate(groupId, artifactId, version, packaging, classifier);
    }
    else
    {
      searchResults = pMcr.searchClassName(className);
    }
    return searchResults;
  }

  private MCRResponse handleGroupIdSearch(MavenCentralRestAPI pMcr)
  {
    RealSearchResults rsr = (RealSearchResults) iActivity;
    String selectedGroupId = rsr.getSelectedGroup();

    MCRResponse searchResults = pMcr.searchForGroupId(selectedGroupId);
    return searchResults;
  }

  private MCRResponse handleArtifactIdSearch(MavenCentralRestAPI pMcr)
  {
    RealSearchResults rsr = (RealSearchResults) iActivity;
    String selectedArtifactId = rsr.getSelectedArtifact();

    MCRResponse searchResults = pMcr.searchForArtifactId(selectedArtifactId);
    return searchResults;
  }

  private MCRResponse handleVersionSearch(MavenCentralRestAPI pMcr, RealSearchResults pRsr)
  {
    String selectedGroupId = pRsr.getSelectedGroup();
    String selectedArtifactId = pRsr.getSelectedArtifact();

    MCRResponse searchResults = pMcr.searchForAllVersions(selectedGroupId, selectedArtifactId);
    return searchResults;
  }

}
