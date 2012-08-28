/**
 * 
 */
package net.worthington.android.maven.search;

import net.worthington.android.maven.search.activities.ArtifactDetails;
import net.worthington.android.maven.search.activities.PomViewActivity;
import net.worthington.android.maven.search.activities.SearchResults;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.restletapi.dao.MCRDoc;
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
    iActivity.dismissDialog(pMsg.arg1);

    if (pMsg.arg2 == Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS)
    {
      intent = new Intent(iActivity, ArtifactDetails.class);
      intent.putExtra(Constants.ARTIFACT, (MCRDoc) pMsg.obj);
      iActivity.startActivity(intent);
    }
    else if (pMsg.arg2 == Constants.PROGRESS_DIALOG_POM_VIEW)
    {
      intent = new Intent(iActivity, PomViewActivity.class);
      intent.putExtra(Constants.ARTIFACT, ((ArtifactDetails)iActivity).getSelectedArtifact());
      intent.putExtra(Constants.POM, (String) pMsg.obj);
      iActivity.startActivity(intent);
    }
    else if (pMsg.arg2 == Constants.PROGRESS_DIALOG_LOAD_MORE_SEARCH_RESULTS)
    {
      ((SearchResults)iActivity).loadMoreResults((MCRResponse) pMsg.obj);
    }
    else
    {
      intent = new Intent(iActivity, SearchResults.class);
      intent.putExtra(Constants.SEARCH_RESULTS, (MCRResponse) pMsg.obj);
      intent.putExtra(Constants.SEARCH_TYPE, pMsg.arg1);
      iActivity.startActivity(intent);
    }
  }
}
