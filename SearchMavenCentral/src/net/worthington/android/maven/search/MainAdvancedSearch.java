package net.worthington.android.maven.search;

import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import net.worthington.android.maven.search.restletapi.MavenCentralRestAPI;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;

public class MainAdvancedSearch extends Activity implements OnClickListener
{
  static final int PROGRESS_DIALOG = 0;
  ProgressThread   progressThread;
  ProgressDialog   progressDialog;

  EditText         groupIdSearchText;
  EditText         artifactIdSearchText;
  EditText         versionSearchText;
  EditText         packagingSearchText;
  EditText         classifierSearchText;
  EditText         classNameSearchText;

  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main_advanced_search);

    groupIdSearchText = (EditText) findViewById(R.id.asGroupIdSearchText);
    groupIdSearchText.setOnClickListener(this);

    artifactIdSearchText = (EditText) findViewById(R.id.asArtifactIdSearchText);
    artifactIdSearchText.setOnClickListener(this);

    versionSearchText = (EditText) findViewById(R.id.asVersionSearchText);
    versionSearchText.setOnClickListener(this);

    packagingSearchText = (EditText) findViewById(R.id.asPackagingSearchText);
    packagingSearchText.setOnClickListener(this);

    classifierSearchText = (EditText) findViewById(R.id.asClassifierSearchText);
    classifierSearchText.setOnClickListener(this);

    classNameSearchText = (EditText) findViewById(R.id.asClassNameSearchText);
    classNameSearchText.setOnClickListener(this);

    ImageButton ib = (ImageButton) findViewById(R.id.searchImageButton);
    ib.setOnClickListener(this);

    Button qsb = (Button) findViewById(R.id.mainQuickSearchButton);
    qsb.setOnClickListener(this);

  }

  @Override
  public void onClick(View v)
  {
    if (v.getId() == R.id.asGroupIdSearchText || v.getId() == R.id.asArtifactIdSearchText
        || v.getId() == R.id.asVersionSearchText || v.getId() == R.id.asPackagingSearchText
        || v.getId() == R.id.asClassifierSearchText || v.getId() == R.id.asClassNameSearchText)
    {
      Log.d(Constants.LOG_TAG, "Edit Text field was clicked");
      EditText et = (EditText) v;

      if ("Search".equals(et.getText().toString()))
      {
        et.setText("");
        et.setTextColor(Color.BLACK);
      }
    }
    else if (v.getId() == R.id.searchImageButton)
    {
      Log.d(Constants.LOG_TAG, "Search button was clicked. Go to Searching");

      // Create a progress dialog so we can see it's searching
      showDialog(PROGRESS_DIALOG);
    }
    else if (v.getId() == R.id.mainQuickSearchButton)
    {
      Log.d(Constants.LOG_TAG, "Quick Search button was clicked. Go to to Quick Search Activity");

      Intent intent = new Intent(MainAdvancedSearch.this, Main.class);
      startActivity(intent);
    }
    else
    {
      Log.d(Constants.LOG_TAG, "Another field was clicked");
    }
  }

  @Override
  protected Dialog onCreateDialog(int pId)
  {
    Dialog returnValue = null;
    switch (pId)
    {
      case PROGRESS_DIALOG:
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
      case PROGRESS_DIALOG:
        progressThread = new ProgressThread(handler);
        progressThread.start();//TODO: is it possible to handle a kill/cancel dialog and kill the thread
        break;
      default:
        return;
    }
  }

  // Define the Handler that receives messages from the thread and update the progress
  final Handler handler = new Handler() {
                          public void handleMessage(Message pMsg)
                          {
                            dismissDialog(PROGRESS_DIALOG);

                            Intent intent = new Intent(MainAdvancedSearch.this, RealSearchResults.class);
                            intent.putExtra("searchResults", (MCRResponse) pMsg.obj);

                            startActivity(intent);
                          }
                        };

  private class ProgressThread extends Thread
  {
    private Handler iHandler;

    ProgressThread(Handler h)
    {
      iHandler = h;
    }

    public void run()
    {//TODO: trim all inputs
      String groupId = groupIdSearchText.getText().toString();
      String artifactId = artifactIdSearchText.getText().toString();
      String version = versionSearchText.getText().toString();
      String packaging = packagingSearchText.getText().toString();
      String classifier = classifierSearchText.getText().toString();
      String className = classNameSearchText.getText().toString();

      MavenCentralRestAPI mcr = new MavenCentralRestAPI(MainAdvancedSearch.this);
      MCRResponse searchResults = null;
      if ("Search".equals(className) || className.trim().length() == 0)
      {
        Log.d(Constants.LOG_TAG, "Searching for " + groupId + ":" + artifactId + ":" + version + ":" + packaging + ":"
            + classifier);

        searchResults = mcr.searchCoordinate(groupId, artifactId, version, packaging, classifier);
      }
      else
      {
        Log.d(Constants.LOG_TAG, "Searching for ClassName: " + className);

        searchResults = mcr.searchClassName(className);
      }

      Message msg = iHandler.obtainMessage();
      msg.obj = searchResults;

      iHandler.sendMessage(msg);
    }
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
