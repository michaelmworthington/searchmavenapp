package net.worthington.android.maven.search;

import java.util.List;

import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.restletapi.dao.MCRDoc;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.ContextMenu.ContextMenuInfo;
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
      TextView allVersionsTV = (TextView) row.findViewById(R.id.allVersionTextView);

      MCRResponse searchResults = (MCRResponse) getIntent().getExtras().getSerializable("searchResults");
      List<MCRDoc> sampleResults = searchResults.getDocs();

      MCRDoc mavenCentralArtifactResult = sampleResults.get(pPosition);

      groupTV.setText(mavenCentralArtifactResult.getG());
      artifactTV.setText(mavenCentralArtifactResult.getA());
      latestVersionTV.setText(mavenCentralArtifactResult.getLatestVersion());

      int versionCount = mavenCentralArtifactResult.getVersionCount();
      if (versionCount > 1)
      {
        allVersionsTV.setText("all(" + versionCount + ")");
      }
      else
      {
        allVersionsTV.setText("");
      }

      registerForContextMenu(row);

      return row;
    }
  }

  @Override
  public void onCreateContextMenu(ContextMenu pMenu, View pV, ContextMenuInfo pMenuInfo)
  {

    super.onCreateContextMenu(pMenu, pV, pMenuInfo);
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.search_results_context_menu, pMenu);
  }

  @Override
  public boolean onContextItemSelected(MenuItem pItem)
  {
    if (pItem.getItemId() == R.id.contextMenuSearchGroupId)
    {
      Log.d(Constants.LOG_TAG, "Search Group ID was clicked");
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchArtifactId)
    {
      Log.d(Constants.LOG_TAG, "Search Artifact Id was clicked");
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchAllVersions)
    {
      Log.d(Constants.LOG_TAG, "Search All Versions was clicked");
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
    if (pItem.getItemId() == R.id.aboutMenuItem)
    {
      Log.d(Constants.LOG_TAG, "About Menu Item was clicked");
    }
    else if (pItem.getItemId() == R.id.helpMenuItem)
    {
      Log.d(Constants.LOG_TAG, "Help Menu Item was clicked");
    }
    else if (pItem.getItemId() == R.id.settingsMenuItem)
    {
      Log.d(Constants.LOG_TAG, "Settings Menu Item was clicked");
    }
    return super.onOptionsItemSelected(pItem);
  }
}
