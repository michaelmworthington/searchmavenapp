package net.worthington.android.maven.search;

import java.util.List;

import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import net.worthington.android.maven.search.restletapi.dao.MCRDoc;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;
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
  @Override
  protected void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    setContentView(R.layout.real_search_results);

    MCRResponse searchResults = (MCRResponse) getIntent().getExtras().getSerializable("searchResults");

    if (searchResults != null)
    {
      TextView tv = (TextView) findViewById(R.id.SearchResultsTextView);
      tv.setText(searchResults.getNumFound() + " Search Results:");

      setListAdapter(new MyAdapter(this, android.R.layout.simple_list_item_1, R.id.groupIdTextView,
                                   searchResults.getDocs()));
    }
    else
    {
      TextView tv = (TextView) findViewById(R.id.SearchResultsTextView);
      tv.setText("Search Results were null - check log");
    }
  }

  private class MyAdapter extends ArrayAdapter<MCRDoc>
  {

    public MyAdapter(Context pContext, int pResource, int pTextViewResourceId, List<MCRDoc> pObjects)
    {
      super(pContext, pResource, pTextViewResourceId, pObjects);
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
      latestVersionTV.setText(mavenCentralArtifactResult.getLatestVersion());
      lastUpdateTV.setText(mavenCentralArtifactResult.getTimestamp().toString("dd-MMM-yyyy"));

      registerForContextMenu(row);
      
      row.setOnClickListener(new OnClickListener() {
        
        @Override
        public void onClick(View pV)
        {
          OptionsMenuDialogActions.mySearchResultsItemSelected(RealSearchResults.this);
          
        }
      });

      return row;
    }
  }

  @Override
  public void onCreateContextMenu(ContextMenu pMenu, View pV, ContextMenuInfo pMenuInfo)
  {

    super.onCreateContextMenu(pMenu, pV, pMenuInfo);
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.search_results_context_menu, pMenu);

    /* TODO: Display the version count in the context menu
     * int versionCount = mavenCentralArtifactResult.getVersionCount(); if (versionCount > 1) {
     * lastUpdateTV.setText("all(" + versionCount + ")"); //todo: replace the version count with the last updated
     * timestamp } else { lastUpdateTV.setText(""); }
     */    
  }

  /**
   * TODO: Implement searches based on the selection
   */
  @Override
  public boolean onContextItemSelected(MenuItem pItem)
  {
    OptionsMenuDialogActions.myContextMenuItemSelected(this,pItem);
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
