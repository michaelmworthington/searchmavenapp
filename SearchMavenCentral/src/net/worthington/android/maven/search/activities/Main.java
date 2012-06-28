package net.worthington.android.maven.search.activities;

import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
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

    setSearchEditText((EditText) findViewById(R.id.searchEditText));
    getSearchEditText().setOnClickListener(this);

    // http://stackoverflow.com/questions/3205339/android-how-to-make-keyboard-enter-button-say-search-and-handle-its-click
    getSearchEditText().setOnEditorActionListener(new TextView.OnEditorActionListener() {
      @Override
      public boolean onEditorAction(TextView pV, int pActionId, KeyEvent pEvent)
      {
        Log.d(Constants.LOG_TAG, "Text View editor action: " + pActionId);
        if (pActionId == EditorInfo.IME_ACTION_SEARCH)
        {
          showDialog(Constants.PROGRESS_DIALOG_QUICK_SEARCH);
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
      if ("Search".equals(getSearchEditText().getText().toString()))
      {
        getSearchEditText().setText("");
        getSearchEditText().setTextColor(Color.BLACK);
      }
    }
    else if (v.getId() == R.id.searchImageButton)
    {
      Log.d(Constants.LOG_TAG, "Search button was clicked. Go to Searching");

      // Create a progress dialog so we can see it's searching
      showDialog(Constants.PROGRESS_DIALOG_QUICK_SEARCH);
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
