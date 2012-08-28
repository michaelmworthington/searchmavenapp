package net.worthington.android.maven.search.constants;

import net.worthington.android.maven.search.ProgressThread;
import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.activities.Preferences;
import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
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

  public static ProgressDialog createProcessDialogHelper(int pId, Context pContext)
  {
    ProgressDialog returnValue = null;
    switch (pId)
    {
      case Constants.PROGRESS_DIALOG_QUICK_SEARCH:
      case Constants.PROGRESS_DIALOG_ADVANCED_SEARCH:
      case Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS:
      case Constants.PROGRESS_DIALOG_GROUPID_SEARCH:
      case Constants.PROGRESS_DIALOG_ARTIFACTID_SEARCH:
      case Constants.PROGRESS_DIALOG_VERSION_SEARCH:
      case Constants.PROGRESS_DIALOG_POM_VIEW:
      case Constants.PROGRESS_DIALOG_LOAD_MORE_SEARCH_RESULTS:
        returnValue = new ProgressDialog(pContext);
        returnValue.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        returnValue.setMessage("Searching...");
        returnValue.setIndeterminate(true);
        returnValue.setCancelable(true);
        break;
      default:
        returnValue = null;
    }
    return returnValue;
  }

  public static void prepareProgressDialogHelper(int pId, Activity pActivity)
  {
    switch (pId)
    {
      case Constants.PROGRESS_DIALOG_QUICK_SEARCH:
      case Constants.PROGRESS_DIALOG_ADVANCED_SEARCH:
      case Constants.PROGRESS_DIALOG_ARTIFACT_DETAILS:
      case Constants.PROGRESS_DIALOG_GROUPID_SEARCH:
      case Constants.PROGRESS_DIALOG_ARTIFACTID_SEARCH:
      case Constants.PROGRESS_DIALOG_VERSION_SEARCH:
      case Constants.PROGRESS_DIALOG_POM_VIEW:
      case Constants.PROGRESS_DIALOG_LOAD_MORE_SEARCH_RESULTS:
        ProgressThread progressThread = new ProgressThread(pActivity, pId);
        progressThread.start();
        // TODO: is it possible to handle a kill/cancel dialog and kill the thread
        break;
      default:
        return;
    }
  }

}
