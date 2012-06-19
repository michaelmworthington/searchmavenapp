package net.worthington.android.maven.search.constants;

import net.worthington.android.maven.search.Preferences;
import net.worthington.android.maven.search.R;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.MenuItem;
import android.view.Window;

public class OptionsMenuDialogActions
{
  public static void myOptionsMenuItemSelected(Context pContext, MenuItem pItem)
  {
    if (pItem.getItemId() == R.id.aboutMenuItem)
    {
      Log.d(Constants.LOG_TAG, "About Menu Item was clicked");
      showDialog(pContext, "About", R.layout.about_dialog, android.R.drawable.ic_menu_info_details);
    }
    else if (pItem.getItemId() == R.id.helpMenuItem)
    {
      Log.d(Constants.LOG_TAG, "Help Menu Item was clicked");
      showDialog(pContext, "Help", R.layout.help_dialog, android.R.drawable.ic_menu_help);
    }
    else if (pItem.getItemId() == R.id.settingsMenuItem)
    {
      Log.d(Constants.LOG_TAG, "Settings Menu Item was clicked");
      Intent intent = new Intent(pContext, Preferences.class);
      pContext.startActivity(intent);
    }
  }

  public static void myContextMenuItemSelected(Context pContext, MenuItem pItem)
  {
    if (pItem.getItemId() == R.id.contextMenuSearchGroupId)
    {
      Log.d(Constants.LOG_TAG, "Search Group ID was clicked");
      showDialog(pContext, "Group Id", R.layout.dummy_search_dialog, android.R.drawable.ic_menu_search);
      // TODO: do a search
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchArtifactId)
    {
      Log.d(Constants.LOG_TAG, "Search Artifact Id was clicked");
      showDialog(pContext, "Artifact Id", R.layout.dummy_search_dialog, android.R.drawable.ic_menu_search);
      // TODO: do a search
    }
    else if (pItem.getItemId() == R.id.contextMenuSearchAllVersions)
    {
      Log.d(Constants.LOG_TAG, "Search All Versions was clicked");
      showDialog(pContext, "All Versions", R.layout.dummy_search_dialog, android.R.drawable.ic_menu_search);
      // TODO: do a search
    }
  }

  public static void mySearchResultsItemSelected(Context pContext)
  {
    Log.d(Constants.LOG_TAG, "Search Item was clicked");
    showDialog(pContext, "Artifact Details", R.layout.dummy_search_dialog, android.R.drawable.ic_menu_search);
    // TODO: get item details
  }

  private static void showDialog(Context pContext, String pTitle, int pLayoutId, int pIconDrawableId)
  {
    Dialog d = new Dialog(pContext);
    d.requestWindowFeature(Window.FEATURE_LEFT_ICON);
    d.setContentView(pLayoutId);
    d.setTitle(pTitle);
    d.setFeatureDrawableResource(Window.FEATURE_LEFT_ICON, pIconDrawableId);
    d.setCanceledOnTouchOutside(true);
    
    d.show();
  }
}
