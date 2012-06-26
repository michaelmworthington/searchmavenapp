/**
 * 
 */
package net.worthington.android.maven.search;

import net.worthington.android.maven.search.activities.ArtifactDetails;
import net.worthington.android.maven.search.activities.RealSearchResults;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import android.app.Activity;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;

/**
 * @author Michael
 * 
 */
public class SearchResultsHandler extends Handler
{
  private Activity iActivity;

  public SearchResultsHandler(Activity pActivity)
  {
    iActivity = pActivity;
  }

  public void handleMessage(Message pMsg)
  {
    Intent intent = null;
    switch (pMsg.arg1)
    {
      case Constants.PROGRESS_DIALOG_QUICK_SEARCH:
      case Constants.PROGRESS_DIALOG_ADVANCED_SEARCH:
      case Constants.PROGRESS_DIALOG_GROUPID_SEARCH:
      case Constants.PROGRESS_DIALOG_ARTIFACTID_SEARCH:
      case Constants.PROGRESS_DIALOG_VERSION_SEARCH:
      {
        iActivity.dismissDialog(pMsg.arg1);
        intent = new Intent(iActivity, RealSearchResults.class);
        intent.putExtra(Constants.SEARCH_RESULTS, (MCRResponse) pMsg.obj);
        intent.putExtra(Constants.SEARCH_TYPE, pMsg.arg1);
        break;
      }
      case Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS:
      {
        iActivity.dismissDialog(Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS);
        intent = new Intent(iActivity, ArtifactDetails.class);
        break;
      }
      default:
      {
        // TODO: bad search type, throw runtime exception, i think?
        break;
      }
    }

    iActivity.startActivity(intent);
  }
}
