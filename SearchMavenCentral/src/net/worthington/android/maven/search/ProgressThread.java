/**
 * 
 */
package net.worthington.android.maven.search;

import net.worthington.android.maven.search.activities.Main;
import net.worthington.android.maven.search.activities.MainAdvancedSearch;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.restletapi.MavenCentralRestAPI;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import android.app.Activity;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
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
        Main m = (Main) iActivity;
        EditText et = m.getSearchEditText();
        Log.d(Constants.LOG_TAG, "Searching for " + et.getText().toString());

        MCRResponse searchResults = mcr.searchBasic(et.getText().toString().trim());

        msg.arg1 = Constants.PROGRESS_DIALOG_QUICK_SEARCH;
        msg.obj = searchResults;
        break;
      }
      case Constants.PROGRESS_DIALOG_ADVANCED_SEARCH:
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
          Log.d(Constants.LOG_TAG, "Searching for " + groupId + ":" + artifactId + ":" + version + ":" + packaging
              + ":" + classifier);

          searchResults = mcr.searchCoordinate(groupId, artifactId, version, packaging, classifier);
        }
        else
        {
          Log.d(Constants.LOG_TAG, "Searching for ClassName: " + className);

          searchResults = mcr.searchClassName(className);
        }

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

        Log.d(Constants.LOG_TAG, "Searching for Artifact Details");
        msg.arg1 = Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS;
        break;
      }
    }

    iHandler.sendMessage(msg);
  }

}
