package net.worthington.android.maven.search.constants;

import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.activities.Preferences;
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
