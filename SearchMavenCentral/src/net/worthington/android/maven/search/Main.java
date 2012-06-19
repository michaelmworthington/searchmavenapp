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
import android.preference.PreferenceManager;
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

public class Main extends Activity implements OnClickListener
{
  static final int PROGRESS_DIALOG = 0;
  ProgressThread   progressThread;
  ProgressDialog   progressDialog;

  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);
    
    //http://www.android-dev.ro/2011/06/12/preferenceactivity-basics/
    //Make sure the defaults are set from XML
    PreferenceManager.setDefaultValues(this, R.xml.preferences, false);

    EditText et = (EditText) findViewById(R.id.searchEditText);
    et.setOnClickListener(this);
    
    // http://stackoverflow.com/questions/3205339/android-how-to-make-keyboard-enter-button-say-search-and-handle-its-click
    et.setOnEditorActionListener(new TextView.OnEditorActionListener() {
      @Override
      public boolean onEditorAction(TextView pV, int pActionId, KeyEvent pEvent)
      {
        Log.d(Constants.LOG_TAG, "Text View editor action: " + pActionId);
        if (pActionId == EditorInfo.IME_ACTION_SEARCH)
        {
          showDialog(PROGRESS_DIALOG);
          return true;
        }
        return false;
      }
    });

    ImageButton ib = (ImageButton) findViewById(R.id.searchImageButton);
    ib.setOnClickListener(this);

    Button asb = (Button) findViewById(R.id.mainAdvancedSearchButton);
    asb.setOnClickListener(this);

  }

  @Override
  public void onClick(View v)
  {
    if (v.getId() == R.id.searchEditText)
    {
      Log.d(Constants.LOG_TAG, "Edit Text field was clicked");
      EditText et = (EditText) findViewById(R.id.searchEditText);
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
    else if (v.getId() == R.id.mainAdvancedSearchButton)
    {
      Log.d(Constants.LOG_TAG, "Advanced Search button was clicked. Go to to Advanced Search Activity");
      
      Intent intent = new Intent(Main.this, MainAdvancedSearch.class);
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
        progressThread.start();
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

                            Intent intent = new Intent(Main.this, RealSearchResults.class);
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
    {
      EditText et = (EditText) findViewById(R.id.searchEditText);
      Log.d(Constants.LOG_TAG, "Searching for " + et.getText().toString());

      MavenCentralRestAPI mcr = new MavenCentralRestAPI(Main.this);
      MCRResponse searchResults = mcr.searchBasic(et.getText().toString());//TODO: trim inputs

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
