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
      {
        iActivity.dismissDialog(Constants.PROGRESS_DIALOG_QUICK_SEARCH);
        intent = new Intent(iActivity, RealSearchResults.class);
        intent.putExtra("searchResults", (MCRResponse) pMsg.obj);
        break;
      }
      case Constants.PROGRESS_DIALOG_ADVANCED_SEARCH:
      {
        iActivity.dismissDialog(Constants.PROGRESS_DIALOG_ADVANCED_SEARCH);
        intent = new Intent(iActivity, RealSearchResults.class);
        intent.putExtra("searchResults", (MCRResponse) pMsg.obj);
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
        break;
      }
    }

    iActivity.startActivity(intent);
  }
}
