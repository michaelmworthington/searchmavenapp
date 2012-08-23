package net.worthington.android.maven.search.activities;

import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import net.worthington.android.maven.search.constants.TextViewHelper;
import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;

public class Main extends Activity implements OnClickListener, OnKeyListener
{
  private EditText searchEditText;

  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);

    // http://www.android-dev.ro/2011/06/12/preferenceactivity-basics/
    // Make sure the defaults are set from XML
    PreferenceManager.setDefaultValues(this, R.xml.preferences, false);

    setSearchEditText(TextViewHelper.lookupEditTextAndSetListeners(this, R.id.searchEditText, Constants.PROGRESS_DIALOG_QUICK_SEARCH));

    ImageButton ib = (ImageButton) findViewById(R.id.searchImageButton);
    ib.setOnClickListener(this);

    Button tsr = (Button) findViewById(R.id.mainTestSearchResultsButton);
    tsr.setOnClickListener(this);

    Button asb = (Button) findViewById(R.id.mainAdvancedSearchButton);
    asb.setOnClickListener(this);
}

  @Override
  public void onClick(View pV)
  {
    if (pV.getId() == R.id.searchEditText)
    {
      Log.d(Constants.LOG_TAG, "Edit Text field was clicked");
      EditText et = (EditText) pV;

      TextViewHelper.clearTextView(et);
    }
    else if (pV.getId() == R.id.searchImageButton)
    {
      Log.d(Constants.LOG_TAG, "Search button was clicked. Go to Searching");

      // Create a progress dialog so we can see it's searching
      showDialog(Constants.PROGRESS_DIALOG_QUICK_SEARCH);
    }
    else if (pV.getId() == R.id.mainTestSearchResultsButton)
    {
      Log.d(Constants.LOG_TAG, "Test Search Results button was clicked. Go to to Test Search Results Activity");

      Intent intent = new Intent(Main.this, TestSearchResults.class);
      startActivity(intent);

    }
    else if (pV.getId() == R.id.mainAdvancedSearchButton)
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
  public boolean onKey(View pV, int pKeyCode, KeyEvent pEvent)
  {
    if (pV.getId() == R.id.searchEditText)
    {
      //Log.d(Constants.LOG_TAG, "Keys were pressed in Edit Text field");
      EditText et = (EditText) pV;

      TextViewHelper.clearTextView(et);
    }
    return false;
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

  public EditText getSearchEditText()
  {
    return searchEditText;
  }

  private void setSearchEditText(EditText searchEditText)
  {
    this.searchEditText = searchEditText;
  }
}
