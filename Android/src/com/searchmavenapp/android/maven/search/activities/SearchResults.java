package com.searchmavenapp.android.maven.search.activities;

import java.util.List;

import android.app.Activity;
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
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ListAdapter;
import android.widget.TextView;

import com.commonsware.cwac.endless.EndlessAdapter;
import com.searchmavenapp.android.maven.search.R;
import com.searchmavenapp.android.maven.search.constants.Constants;
import com.searchmavenapp.android.maven.search.constants.OptionsMenuDialogActions;
import com.searchmavenapp.android.maven.search.restletapi.MavenCentralRestAPI;
import com.searchmavenapp.android.maven.search.restletapi.dao.MCRDoc;
import com.searchmavenapp.android.maven.search.restletapi.dao.MCRResponse;

public class SearchResults extends ListActivity
{
  private int          iSearchType;
  private String       iSelectedGroup;
  private String       iSelectedArtifact;
  private String       iSelectedVersion;
  private Integer      iSelectedVersionCount;
  private ListAdapter  iAdapter;

  @Override
  public void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    setContentView(R.layout.search_results);

    MCRResponse  mcrResponse = (MCRResponse) getIntent().getExtras().getSerializable(Constants.SEARCH_RESULTS);
    iSearchType = (Integer) getIntent().getExtras().getSerializable(Constants.SEARCH_TYPE);

    if (mcrResponse != null)
    {
      TextView tv = (TextView) findViewById(R.id.SearchResultsTextView);
      tv.setText(mcrResponse.getNumFound() + " " + getSearchTypeString(iSearchType) + " Search Results:");

      MyAdapter myAdapter = new MyAdapter(this, mcrResponse);
      if (myAdapter.isHaveAllResults())
      {
        iAdapter = myAdapter;
      }
      else
      {
        iAdapter = new MyEndlessAdapter(this, myAdapter, R.layout.search_results_progress_item);
      }
      
      setListAdapter(iAdapter);

      registerForContextMenu(getListView());

      getListView().setOnItemClickListener(new OnItemClickListener() {

        @Override
        public void onItemClick(AdapterView<?> pArg0, View pV, int pArg2, long pArg3)
        {
          if (Constants.LOG_ENABLED) { Log.d(Constants.LOG_TAG, "Search Result was clicked"); }
          setSelectedGroup(((TextView) pV.findViewById(R.id.groupIdTextView)).getText().toString());
          setSelectedArtifact(((TextView) pV.findViewById(R.id.artifactIdTextView)).getText().toString());
          setSelectedVersion(((TextView) pV.findViewById(R.id.latestVersionTextView)).getText().toString());
          setSelectedVersionCount(Integer.valueOf(((TextView) pV.findViewById(R.id.versionCountTextView)).getText()
                                                                                                         .toString()));
          // Create a progress dialog so we can see it's searching
          showDialog(Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS);
        }
      });
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

  private class MyEndlessAdapter extends EndlessAdapter
  {
    MyAdapter iMyAdapter;
    
    public MyEndlessAdapter(Context pContext, ListAdapter pWrapped, int pPendingResource)
    {
      super(pContext, pWrapped, pPendingResource);
      iMyAdapter = (MyAdapter)getWrappedAdapter();
    }

    @Override
    protected void appendCachedData()
    {
      if (iMyAdapter.isHaveAllResults() == false)
      {
        if (iMyAdapter.getResponse() != null)
        {
          iMyAdapter.addResults(iMyAdapter.getResponse().getDocs());
        }
      }
    }

    /**
     * Retrieve the additional data in the background
     * @return true if there is more data to be fetched, false if we got it all
     */
    @Override
    protected boolean cacheInBackground() throws Exception
    {
      if (iMyAdapter.isHaveAllResults() == false)
      {
        MavenCentralRestAPI mcr = new MavenCentralRestAPI(SearchResults.this);
        MCRResponse searchResults = mcr.loadMoreResults(iMyAdapter.getResponse());
        iMyAdapter.setResponse(searchResults);

        return true;
      }
      else
      {
        return false;
      }
    }
  }
  
  private class MyAdapter extends BaseAdapter
  {

    private Activity     iActivity;
    private MCRResponse iResponse;
    private List<MCRDoc> iData;

    public MyAdapter(Activity pActivity, MCRResponse pResponse)
    {
      iActivity = pActivity;
      iResponse = pResponse;
      iData = pResponse.getDocs();
    }
    
    public boolean isHaveAllResults()
    {
      return iData.size() >= iResponse.getNumFound();
    }
    public void addResults(List<MCRDoc> pData)
    {
      iData.addAll(pData);
    }
    
    public MCRResponse getResponse()
    {
      return iResponse;
    }

    private void setResponse(MCRResponse pResponse)
    {
      iResponse = pResponse;;
    }

    @Override
    public int getCount()
    {
      return iData.size();
    }

    @Override
    public Object getItem(int pPosition)
    {
      return pPosition;
    }

    @Override
    public long getItemId(int pPosition)
    {
      return pPosition;
    }

    @Override
    public View getView(int pPosition, View pConvertView, ViewGroup pParent)
    {
      View row = pConvertView;
      if (pConvertView == null)
      {
        LayoutInflater inflater = (LayoutInflater) iActivity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        row = inflater.inflate(R.layout.search_results_item, null);
      }

      TextView groupTV = (TextView) row.findViewById(R.id.groupIdTextView);
      TextView artifactTV = (TextView) row.findViewById(R.id.artifactIdTextView);
      TextView latestVersionTV = (TextView) row.findViewById(R.id.latestVersionTextView);
      TextView lastUpdateTV = (TextView) row.findViewById(R.id.lastUpdateTextView);
      TextView versionCount = (TextView) row.findViewById(R.id.versionCountTextView);

      MCRDoc mavenCentralArtifactResult = iData.get(pPosition);

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
    AdapterView.AdapterContextMenuInfo menuItem = (AdapterView.AdapterContextMenuInfo) pMenuInfo;
    View menuView = menuItem.targetView;
    setSelectedGroup(((TextView) menuView.findViewById(R.id.groupIdTextView)).getText().toString());
    setSelectedArtifact(((TextView) menuView.findViewById(R.id.artifactIdTextView)).getText().toString());
    setSelectedVersion(((TextView) menuView.findViewById(R.id.latestVersionTextView)).getText().toString());
    setSelectedVersionCount(Integer.valueOf(((TextView) menuView.findViewById(R.id.versionCountTextView)).getText()
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
      if (Constants.LOG_ENABLED) { Log.d(Constants.LOG_TAG, "Search Group ID was clicked: " + getSelectedGroup()); }
      showDialog(Constants.PROGRESS_DIALOG_GROUPID_SEARCH);
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchArtifactId)
    {
      if (Constants.LOG_ENABLED) { Log.d(Constants.LOG_TAG, "Search Artifact Id was clicked: " + getSelectedArtifact()); }
      showDialog(Constants.PROGRESS_DIALOG_ARTIFACTID_SEARCH);
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchAllVersions)
    {
      if (Constants.LOG_ENABLED) { Log.d(Constants.LOG_TAG, "Search All Versions was clicked"); }
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
