package net.worthington.android.maven.search;

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
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageButton;

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

    EditText et = (EditText) findViewById(R.id.searchEditText);
    et.setOnClickListener(this);

    ImageButton ib = (ImageButton) findViewById(R.id.imageButton1);
    ib.setOnClickListener(this);

  }

  @Override
  public void onClick(View v)
  {
    if (v.getId() == R.id.searchEditText)
    {
      Log.d("net.worthington", "Edit Text field was clicked");
      EditText et = (EditText) findViewById(R.id.searchEditText);
      if ("Search".equals(et.getText().toString()))
      {
        et.setText("");
        et.setTextColor(Color.BLACK);
      }
    }
    else if (v.getId() == R.id.imageButton1)
    {
      Log.d("net.worthington", "Search button was clicked. Go to Searching");

      // Create a progress dialog so we can see it's searching
      showDialog(PROGRESS_DIALOG);
    }
    else
    {
      Log.d("net.worthington", "Another field was clicked");
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
      Log.d("net.worthington", "Searching for " + et.getText().toString());

      MavenCentralRestAPI mcr = new MavenCentralRestAPI();
      MCRResponse searchResults = mcr.search(et.getText().toString());

      Message msg = iHandler.obtainMessage();
      msg.obj = searchResults;

      iHandler.sendMessage(msg);
    }
  }
}
