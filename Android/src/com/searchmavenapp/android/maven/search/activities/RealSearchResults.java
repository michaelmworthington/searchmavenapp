package com.searchmavenapp.android.maven.search.activities;

import java.util.List;

import com.searchmavenapp.android.maven.search.R;
import com.searchmavenapp.android.maven.search.constants.Constants;
import com.searchmavenapp.android.maven.search.constants.OptionsMenuDialogActions;
import com.searchmavenapp.android.maven.search.restletapi.dao.MCRDoc;
import com.searchmavenapp.android.maven.search.restletapi.dao.MCRResponse;

import android.app.Dialog;
import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;
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
import android.widget.Button;
import android.widget.TextView;

public class RealSearchResults extends ListActivity
{
  private int     iSearchType;
  private String  iSelectedGroup;
  private String  iSelectedArtifact;
  private String  iSelectedVersion;
  private Integer iSelectedVersionCount;

  @Override
  protected void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    setContentView(R.layout.real_search_results);

    MCRResponse searchResults = (MCRResponse) getIntent().getExtras().getSerializable(Constants.SEARCH_RESULTS);
    iSearchType = (Integer) getIntent().getExtras().getSerializable(Constants.SEARCH_TYPE);

    if (searchResults != null)
    {
      TextView tv = (TextView) findViewById(R.id.SearchResultsTextView);
      tv.setText(searchResults.getNumFound() + " " + getSearchTypeString(iSearchType) + " Search Results:");

      setListAdapter(new MyAdapter(this, R.layout.real_search_results_item, searchResults.getDocs()));
      getListView().setTextFilterEnabled(true);

      // Creating a button - Load More
      Button btnLoadMore = new Button(this);
      btnLoadMore.setText("Load More");

      // Adding button to listview at footer
      getListView().addFooterView(btnLoadMore);
    }
    else
    {
      TextView tv = (TextView) findViewById(R.id.SearchResultsTextView);
      tv.setText("Search Results were null - check log");
    }
  }

  private String getSearchTypeString(int pSearchType)
  {
    String returnValue = "";
    switch (pSearchType)
    {
      case Constants.PROGRESS_DIALOG_QUICK_SEARCH:
        returnValue = "Quick";
        break;
      case Constants.PROGRESS_DIALOG_ADVANCED_SEARCH:
        returnValue = "Advanced";
        break;
      case Constants.PROGRESS_DIALOG_GROUPID_SEARCH:
        returnValue = "GroupId";
        break;
      case Constants.PROGRESS_DIALOG_ARTIFACTID_SEARCH:
        returnValue = "ArtifactId";
        break;
      case Constants.PROGRESS_DIALOG_VERSION_SEARCH:
        returnValue = "All Versions";
        break;
    }
    return returnValue;
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
      View row = inflater.inflate(R.layout.real_search_results_item, pParent, false);
      TextView groupTV = (TextView) row.findViewById(R.id.groupIdTextView);
      TextView artifactTV = (TextView) row.findViewById(R.id.artifactIdTextView);
      TextView latestVersionTV = (TextView) row.findViewById(R.id.latestVersionTextView);
      TextView lastUpdateTV = (TextView) row.findViewById(R.id.lastUpdateTextView);
      TextView versionCount = (TextView) row.findViewById(R.id.versionCountTextView);

      MCRResponse searchResults = (MCRResponse) getIntent().getExtras().getSerializable(Constants.SEARCH_RESULTS);
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
      versionCount.setText(Integer.toString(mavenCentralArtifactResult.getVersionCount()));

      registerForContextMenu(row);

      row.setOnClickListener(new OnClickListener() {

        @Override
        public void onClick(View pV)
        {
          Log.d(Constants.LOG_TAG, "Search Item was clicked");
          setSelectedGroup(((TextView) pV.findViewById(R.id.groupIdTextView)).getText().toString());
          setSelectedArtifact(((TextView) pV.findViewById(R.id.artifactIdTextView)).getText().toString());
          setSelectedVersion(((TextView) pV.findViewById(R.id.latestVersionTextView)).getText().toString());
          setSelectedVersionCount(Integer.valueOf(((TextView) pV.findViewById(R.id.versionCountTextView)).getText()
                                                                                                         .toString()));
          // Create a progress dialog so we can see it's searching
          showDialog(Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS);
        }
      });

      return row;
    }
  }

  @Override
  protected Dialog onCreateDialog(int pId)
  {
    return OptionsMenuDialogActions.createProcessDialogHelper(pId, this);
  }

  @Override
  protected void onPrepareDialog(int pId, Dialog pDialog)
  {
    OptionsMenuDialogActions.prepareProgressDialogHelper(pId, this);
  }

  @Override
  public void onCreateContextMenu(ContextMenu pMenu, View pV, ContextMenuInfo pMenuInfo)
  {
    setSelectedGroup(((TextView) pV.findViewById(R.id.groupIdTextView)).getText().toString());
    setSelectedArtifact(((TextView) pV.findViewById(R.id.artifactIdTextView)).getText().toString());
    setSelectedVersion(((TextView) pV.findViewById(R.id.latestVersionTextView)).getText().toString());
    setSelectedVersionCount(Integer.valueOf(((TextView) pV.findViewById(R.id.versionCountTextView)).getText()
                                                                                                   .toString()));

    super.onCreateContextMenu(pMenu, pV, pMenuInfo);
    pMenu.setHeaderTitle("Search By:");

    if (iSearchType != Constants.PROGRESS_DIALOG_GROUPID_SEARCH)
    {
      pMenu.add(Menu.NONE, R.id.contextMenuSearchGroupId, 1, "Group Id");
    }
    if (iSearchType != Constants.PROGRESS_DIALOG_ARTIFACTID_SEARCH)
    {
      pMenu.add(Menu.NONE, R.id.contextMenuSearchArtifactId, 2, "Artifact Id");
    }
    if (iSearchType != Constants.PROGRESS_DIALOG_VERSION_SEARCH)
    {
      pMenu.add(Menu.NONE, R.id.contextMenuSearchAllVersions, 3, "All " + getSelectedVersionCount() + " Versions");
    }
  }

  @Override
  public boolean onContextItemSelected(MenuItem pItem)
  {
    if (pItem.getItemId() == R.id.contextMenuSearchGroupId)
    {
      Log.d(Constants.LOG_TAG, "Search Group ID was clicked: " + getSelectedGroup());
      showDialog(Constants.PROGRESS_DIALOG_GROUPID_SEARCH);
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchArtifactId)
    {
      Log.d(Constants.LOG_TAG, "Search Artifact Id was clicked: " + getSelectedArtifact());
      showDialog(Constants.PROGRESS_DIALOG_ARTIFACTID_SEARCH);
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchAllVersions)
    {
      Log.d(Constants.LOG_TAG, "Search All Versions was clicked");
      showDialog(Constants.PROGRESS_DIALOG_VERSION_SEARCH);
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

  public Integer getSelectedVersionCount()
  {
    return iSelectedVersionCount;
  }

  private void setSelectedVersionCount(Integer selectedVersionCount)
  {
    iSelectedVersionCount = selectedVersionCount;
  }

  public String getSelectedGroup()
  {
    return iSelectedGroup;
  }

  private void setSelectedGroup(String selectedGroup)
  {
    iSelectedGroup = selectedGroup;
  }

  public String getSelectedArtifact()
  {
    return iSelectedArtifact;
  }

  private void setSelectedArtifact(String selectedArtifact)
  {
    iSelectedArtifact = selectedArtifact;
  }

  public String getSelectedVersion()
  {
    return iSelectedVersion;
  }

  private void setSelectedVersion(String selectedVersion)
  {
    iSelectedVersion = selectedVersion;
  }
}
