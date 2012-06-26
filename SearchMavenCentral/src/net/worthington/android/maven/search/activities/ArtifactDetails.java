package net.worthington.android.maven.search.activities;

import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

public class ArtifactDetails extends Activity implements OnItemSelectedListener, OnClickListener
{
  @Override
  protected void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    setContentView(R.layout.artifact_details);

    // MCRDoc searchResults = (MCRDoc) getIntent().getExtras().getSerializable(Constants.ARTIFACT);
    Log.d(Constants.LOG_TAG, "Showing Artifact Details");// TODO: fill in the real values

    setValuesOnDependencySpinner();

    Button bPom = (Button) findViewById(R.id.displayPom);
    bPom.setOnClickListener(this);

    Button bFileList = (Button) findViewById(R.id.displayArtifactFileList);
    bFileList.setOnClickListener(this);
  }

  private void setValuesOnDependencySpinner()
  {
    Spinner spinner = (Spinner) findViewById(R.id.dependencySpinner);
    ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.dependency_formats,
                                                                         android.R.layout.simple_spinner_item);
    adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
    spinner.setAdapter(adapter);
    spinner.setOnItemSelectedListener(this);
  }

  @Override
  public void onItemSelected(AdapterView<?> pParent, View pView, int pPos, long pId)
  {
    Object o = pParent.getItemAtPosition(pPos);//a String :)
    Log.d(Constants.LOG_TAG, "Spinner Item Selected: " + o.toString());
  }

  @Override
  public void onNothingSelected(AdapterView<?> pParent)
  {
    Log.d(Constants.LOG_TAG, "Spinner No Item Selected");
  }

  @Override
  public void onClick(View pV)
  {
    Intent intent = null;
    switch (pV.getId())
    {
      case R.id.displayPom:
      {
        intent = new Intent(ArtifactDetails.this, PomViewActivity.class);
        break;
      }
      case R.id.displayArtifactFileList:
      {
        intent = new Intent(ArtifactDetails.this, ArtifactFileListActivity.class);
        break;
      }
    }
    startActivity(intent);
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
