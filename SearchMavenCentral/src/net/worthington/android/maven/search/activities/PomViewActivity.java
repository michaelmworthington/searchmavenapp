package net.worthington.android.maven.search.activities;

import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import net.worthington.android.maven.search.restletapi.dao.MCRDoc;
import android.app.Activity;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.TextView;

public class PomViewActivity extends Activity
{
  @Override
  protected void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    setContentView(R.layout.pom_view);

    Log.d(Constants.LOG_TAG, "Showing POM Details");
    String pomText = (String) getIntent().getExtras().getSerializable(Constants.POM);
    MCRDoc selectedArtifact = (MCRDoc) getIntent().getExtras().getSerializable(Constants.ARTIFACT);

    TextView contentsTV = (TextView) findViewById(R.id.pomTextView);
    TextView headerTV = (TextView) findViewById(R.id.pomHeaderTextView);

    // TODO: syntax highlighting??
    contentsTV.setText(pomText);
    contentsTV.setMovementMethod(new ScrollingMovementMethod());
    contentsTV.setHorizontallyScrolling(true);
    headerTV.setText(selectedArtifact.getGAV());
    
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
