package net.worthington.android.maven.search.activities;

import java.util.List;

import net.worthington.android.maven.search.ProgressThread;
import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.SearchResultsHandler;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import net.worthington.android.maven.search.restletapi.dao.MCRDoc;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import android.app.Dialog;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

public class RealSearchResults extends ListActivity
{
  private ProgressThread progressThread;
  private ProgressDialog progressDialog;
  private Handler        iHandler;

  @Override
  protected void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    setContentView(R.layout.real_search_results);

    MCRResponse searchResults = (MCRResponse) getIntent().getExtras().getSerializable("searchResults");

    if (searchResults != null)
    {
      TextView tv = (TextView) findViewById(R.id.SearchResultsTextView);
      // TODO: add in where the search came from so we can display and also adjust the long tap menu list - i.e. no
      // sense searching by group id on a group id search result list
      tv.setText(searchResults.getNumFound() + " Search Results:");

      setListAdapter(new MyAdapter(this, R.layout.search_results_item, searchResults.getDocs()));
      // TODO: getListView().setTextFilterEnabled(true);
    }
    else
    {
      TextView tv = (TextView) findViewById(R.id.SearchResultsTextView);
      tv.setText("Search Results were null - check log");
    }

    // Define the Handler that receives messages from the thread and update the progress
    iHandler = new SearchResultsHandler(this);
  }

  private class MyAdapter extends ArrayAdapter<MCRDoc>
  {

    public MyAdapter(Context pContext, int pTextViewResourceId, List<MCRDoc> pObjects)
    {
      super(pContext, pTextViewResourceId, pObjects);
    }

    @Override
    public View getView(int pPosition, View pConvertView, ViewGroup pParent)
    {
      LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
      View row = inflater.inflate(R.layout.search_results_item, pParent, false);
      TextView groupTV = (TextView) row.findViewById(R.id.groupIdTextView);
      TextView artifactTV = (TextView) row.findViewById(R.id.artifactIdTextView);
      TextView latestVersionTV = (TextView) row.findViewById(R.id.latestVersionTextView);
      TextView lastUpdateTV = (TextView) row.findViewById(R.id.lastUpdateTextView);

      MCRResponse searchResults = (MCRResponse) getIntent().getExtras().getSerializable("searchResults");
      List<MCRDoc> sampleResults = searchResults.getDocs();

      MCRDoc mavenCentralArtifactResult = sampleResults.get(pPosition);

      groupTV.setText(mavenCentralArtifactResult.getG());
      artifactTV.setText(mavenCentralArtifactResult.getA());

      String version = mavenCentralArtifactResult.getLatestVersion();
      if (version == null || version.trim().length() == 0)
      {
        version = mavenCentralArtifactResult.getV();
      }

      latestVersionTV.setText(version);
      lastUpdateTV.setText(mavenCentralArtifactResult.getTimestamp().toString("dd-MMM-yyyy"));

      registerForContextMenu(row);

      row.setOnClickListener(new OnClickListener() {

        @Override
        public void onClick(View pV)
        {
          Log.d(Constants.LOG_TAG, "Search Item was clicked");
          // Create a progress dialog so we can see it's searching
          showDialog(Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS);// TODO: pass info on the artifact that was selected
        }
      });

      return row;
    }
  }

  @Override
  protected Dialog onCreateDialog(int pId)
  {
    Dialog returnValue = null;
    switch (pId)
    {
      case Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS:
        progressDialog = new ProgressDialog(this);
        progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        progressDialog.setMessage("Searching...");
        progressDialog.setIndeterminate(true);
        progressDialog.setCancelable(true);
        returnValue = progressDialog;
        break;
      default:
        returnValue = null;
    }
    return returnValue;
  }

  @Override
  protected void onPrepareDialog(int pId, Dialog pDialog)
  {
    switch (pId)
    {
      case Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS:
        progressThread = new ProgressThread(iHandler, this, Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS);
        progressThread.start();
        break;
      default:
        return;
    }
  }

  @Override
  public void onCreateContextMenu(ContextMenu pMenu, View pV, ContextMenuInfo pMenuInfo)
  {

    super.onCreateContextMenu(pMenu, pV, pMenuInfo);
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.search_results_context_menu, pMenu);
// TODO: save the item that was selected
    /*
     * TODO: Display the version count in the context menu int versionCount =
     * mavenCentralArtifactResult.getVersionCount(); if (versionCount > 1) { lastUpdateTV.setText("all(" + versionCount
     * + ")"); //TODO: replace the version count with the last updated timestamp } else { lastUpdateTV.setText(""); }
     */
  }

  /**
   * TODO: Implement searches based on the selection
   */
  @Override
  public boolean onContextItemSelected(MenuItem pItem)
  {

    Log.d(Constants.LOG_TAG, "Search Results Item: " + pItem.toString() + " menuInfo: " + pItem.getMenuInfo());

    // ExpandableListContextMenuInfo info = (ExpandableListContextMenuInfo) item.getMenuInfo();

    // String title = ((TextView) info.targetView).getText().toString();

    if (pItem.getItemId() == R.id.contextMenuSearchGroupId)
    {
      Log.d(Constants.LOG_TAG, "Search Group ID was clicked");
      // showDialog(pContext, "Group Id", R.layout.dummy_search_dialog, android.R.drawable.ic_menu_search);
      // TODO: do a search
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchArtifactId)
    {
      Log.d(Constants.LOG_TAG, "Search Artifact Id was clicked");
      // showDialog(pContext, "Artifact Id", R.layout.dummy_search_dialog, android.R.drawable.ic_menu_search);
      // TODO: do a search
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchAllVersions)
    {
      Log.d(Constants.LOG_TAG, "Search All Versions was clicked");
      // showDialog(pContext, "All Versions", R.layout.dummy_search_dialog, android.R.drawable.ic_menu_search);
      // TODO: do a search
    }

    return super.onContextItemSelected(pItem);
  }

  @Override
  public boolean onCreateOptionsMenu(Menu pMenu)
  {
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.menu, pMenu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem pItem)
  {
    OptionsMenuDialogActions.myOptionsMenuItemSelected(this, pItem);
    return super.onOptionsItemSelected(pItem);
  }
}
