package net.worthington.android.maven.search.activities;

import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import android.app.Activity;
import android.os.Bundle;
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
    // TODO: fill in the real values

    TextView tv = (TextView) findViewById(R.id.pomTextView);
    tv.setText("<project>...</project>");
    // TODO: make it scroll
    // TODO: syntax highlighting??
    // TODO: set @+id/pomHeaderTextView title with artifact information
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
