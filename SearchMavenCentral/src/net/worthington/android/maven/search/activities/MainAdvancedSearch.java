package net.worthington.android.maven.search.activities;

import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;

public class MainAdvancedSearch extends Activity implements OnClickListener
{
  private EditText       groupIdSearchText;
  private EditText       artifactIdSearchText;
  private EditText       versionSearchText;
  private EditText       packagingSearchText;
  private EditText       classifierSearchText;
  private EditText       classNameSearchText;

  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main_advanced_search);

    setGroupIdSearchText((EditText) findViewById(R.id.asGroupIdSearchText));
    getGroupIdSearchText().setOnClickListener(this);

    setArtifactIdSearchText((EditText) findViewById(R.id.asArtifactIdSearchText));
    getArtifactIdSearchText().setOnClickListener(this);

    setVersionSearchText((EditText) findViewById(R.id.asVersionSearchText));
    getVersionSearchText().setOnClickListener(this);

    setPackagingSearchText((EditText) findViewById(R.id.asPackagingSearchText));
    getPackagingSearchText().setOnClickListener(this);

    setClassifierSearchText((EditText) findViewById(R.id.asClassifierSearchText));
    getClassifierSearchText().setOnClickListener(this);

    setClassNameSearchText((EditText) findViewById(R.id.asClassNameSearchText));
    getClassNameSearchText().setOnClickListener(this);

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
      showDialog(Constants.PROGRESS_DIALOG_ADVANCED_SEARCH);
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

  public EditText getGroupIdSearchText()
  {
    return groupIdSearchText;
  }

  private void setGroupIdSearchText(EditText groupIdSearchText)
  {
    this.groupIdSearchText = groupIdSearchText;
  }

  public EditText getArtifactIdSearchText()
  {
    return artifactIdSearchText;
  }

  private void setArtifactIdSearchText(EditText artifactIdSearchText)
  {
    this.artifactIdSearchText = artifactIdSearchText;
  }

  public EditText getVersionSearchText()
  {
    return versionSearchText;
  }

  private void setVersionSearchText(EditText versionSearchText)
  {
    this.versionSearchText = versionSearchText;
  }

  public EditText getPackagingSearchText()
  {
    return packagingSearchText;
  }

  private void setPackagingSearchText(EditText packagingSearchText)
  {
    this.packagingSearchText = packagingSearchText;
  }

  public EditText getClassifierSearchText()
  {
    return classifierSearchText;
  }

  private void setClassifierSearchText(EditText classifierSearchText)
  {
    this.classifierSearchText = classifierSearchText;
  }

  public EditText getClassNameSearchText()
  {
    return classNameSearchText;
  }

  private void setClassNameSearchText(EditText classNameSearchText)
  {
    this.classNameSearchText = classNameSearchText;
  }
}
