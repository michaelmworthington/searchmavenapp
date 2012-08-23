package net.worthington.android.maven.search.activities;

import net.worthington.android.maven.search.KeyboardSearchEditorActionListener;
import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import net.worthington.android.maven.search.constants.TextViewHelper;
import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
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

public class MainAdvancedSearch extends Activity implements OnClickListener, OnKeyListener
{
  private EditText groupIdSearchText;
  private EditText artifactIdSearchText;
  private EditText versionSearchText;
  private EditText packagingSearchText;
  private EditText classifierSearchText;
  private EditText classNameSearchText;

  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main_advanced_search);

    setGroupIdSearchText(TextViewHelper.lookupEditTextAndSetListeners(this, R.id.asGroupIdSearchText, Constants.PROGRESS_DIALOG_ADVANCED_SEARCH));
    setArtifactIdSearchText(TextViewHelper.lookupEditTextAndSetListeners(this, R.id.asArtifactIdSearchText, Constants.PROGRESS_DIALOG_ADVANCED_SEARCH));
    setVersionSearchText(TextViewHelper.lookupEditTextAndSetListeners(this, R.id.asVersionSearchText, Constants.PROGRESS_DIALOG_ADVANCED_SEARCH));
    setPackagingSearchText(TextViewHelper.lookupEditTextAndSetListeners(this, R.id.asPackagingSearchText, Constants.PROGRESS_DIALOG_ADVANCED_SEARCH));
    setClassifierSearchText(TextViewHelper.lookupEditTextAndSetListeners(this, R.id.asClassifierSearchText, Constants.PROGRESS_DIALOG_ADVANCED_SEARCH));
    setClassNameSearchText(TextViewHelper.lookupEditTextAndSetListeners(this, R.id.asClassNameSearchText, Constants.PROGRESS_DIALOG_ADVANCED_SEARCH));

    ImageButton ib = (ImageButton) findViewById(R.id.searchImageButton);
    ib.setOnClickListener(this);

    Button qsb = (Button) findViewById(R.id.mainQuickSearchButton);
    qsb.setOnClickListener(this);
  }

  @Override
  public void onClick(View pV)
  {
    if (pV.getId() == R.id.asGroupIdSearchText || pV.getId() == R.id.asArtifactIdSearchText
        || pV.getId() == R.id.asVersionSearchText || pV.getId() == R.id.asPackagingSearchText
        || pV.getId() == R.id.asClassifierSearchText || pV.getId() == R.id.asClassNameSearchText)
    {
      Log.d(Constants.LOG_TAG, "Edit Text field was clicked");
      EditText et = (EditText) pV;

      TextViewHelper.clearTextView(et);
    }
    else if (pV.getId() == R.id.searchImageButton)
    {
      Log.d(Constants.LOG_TAG, "Search button was clicked. Go to Searching");

      // Create a progress dialog so we can see it's searching
      showDialog(Constants.PROGRESS_DIALOG_ADVANCED_SEARCH);
    }
    else if (pV.getId() == R.id.mainQuickSearchButton)
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
  public boolean onKey(View pV, int pKeyCode, KeyEvent pEvent)
  {
    if (pV.getId() == R.id.asGroupIdSearchText || pV.getId() == R.id.asArtifactIdSearchText
        || pV.getId() == R.id.asVersionSearchText || pV.getId() == R.id.asPackagingSearchText
        || pV.getId() == R.id.asClassifierSearchText || pV.getId() == R.id.asClassNameSearchText)
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
