package net.worthington.android.maven.search.activities;

import net.worthington.android.maven.search.R;
import net.worthington.android.maven.search.constants.Constants;
import net.worthington.android.maven.search.constants.OptionsMenuDialogActions;
import net.worthington.android.maven.search.restletapi.dao.MCRDoc;
import android.app.Activity;
import android.app.Dialog;
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
import android.widget.TextView;

public class ArtifactDetails extends Activity implements OnItemSelectedListener, OnClickListener
{
  private TextView iGTV;
  private TextView iATV;
  private TextView iVTV;

  private MCRDoc iSelectedArtifact;

  @Override
  protected void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    setContentView(R.layout.artifact_details);

    Log.d(Constants.LOG_TAG, "Showing Artifact Details");
    setSelectedArtifact((MCRDoc) getIntent().getExtras().getSerializable(Constants.ARTIFACT));
    setGTV((TextView) findViewById(R.id.adGroupIdText));
    setATV((TextView) findViewById(R.id.adArtifactIdText));
    setVTV((TextView) findViewById(R.id.adVersionText));

    getGTV().setText(getSelectedArtifact().getG());
    getATV().setText(getSelectedArtifact().getA());
    getVTV().setText(getSelectedArtifact().getV());

    setValuesOnDependencySpinner();

    Button bPom = (Button) findViewById(R.id.displayPom);
    bPom.setOnClickListener(this);

    /*
     * TODO: disabled for now until i can get some information on how to get the file list Button bFileList = (Button)
     * findViewById(R.id.displayArtifactFileList); bFileList.setOnClickListener(this);
     */
  }

  private void setValuesOnDependencySpinner()
  {
    Spinner spinner = (Spinner) findViewById(R.id.dependencySpinner);
    ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item,
                                                            Constants.DEPENDENCY_FORMATS);
    adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
    spinner.setAdapter(adapter);
    spinner.setOnItemSelectedListener(this);
  }

  @Override
  public void onItemSelected(AdapterView<?> pParent, View pView, int pPos, long pId)
  {
    TextView dtTV = (TextView) findViewById(R.id.adDependencyText);
    String dependencyText = "";
    String dependencySelection = (String) pParent.getItemAtPosition(pPos);
    Log.d(Constants.LOG_TAG, "Spinner Item Selected: " + dependencySelection);

    if (Constants.DEP_APACHE_MAVEN.equals(dependencySelection))
    {
      dependencyText = "<dependency>\n    <groupId>%s</groupId>\n    <artifactId>%s</artifactId>\n    <version>%s</version>\n</dependency>";
    }
    else if (Constants.DEP_APACHE_BUILDR.equals(dependencySelection))
    {
      dependencyText = "'%s:%s:jar:%s'";
    }
    else if (Constants.DEP_APACHE_IVY.equals(dependencySelection))
    {
      dependencyText = "<dependency org=\"%s\" name=\"%s\" rev=\"%s\" >\n    <artifact name=\"%2$s\" type=\"jar\" />\n</dependency>";
    }
    else if (Constants.DEP_GROOVY_GRAPE.equals(dependencySelection))
    {
      dependencyText = "@Grapes(\n@Grab(group='%s', module='%s', version='%s')\n)";
    }
    else if (Constants.DEP_GRAILS.equals(dependencySelection))
    {
      dependencyText = "compile '%s:%s:%s'";
    }
    else if (Constants.DEP_SCALA_SBT.equals(dependencySelection))
    {
      dependencyText = "libraryDependencies += \"%s\" %% \"%s\" %% \"%s\"";
    }

    dtTV.setText(String.format(dependencyText, getGTVText(), getATVText(), getVTVText()));
}

  @Override
  public void onNothingSelected(AdapterView<?> pParent)
  {
    Log.d(Constants.LOG_TAG, "Spinner No Item Selected");
  }

  @Override
  public void onClick(View pV)
  {
    switch (pV.getId())
    {
      case R.id.displayPom:
      {
        showDialog(Constants.PROGRESS_DIALOG_POM_VIEW);
        break;
      }
      /*
       * TODO: disabling until i can figure out how to get the file list case R.id.displayArtifactFileList: { intent =
       * new Intent(ArtifactDetails.this, ArtifactFileListActivity.class); break; }
       */
      default:
      {
        break;
      }
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

  public TextView getGTV()
  {
    return iGTV;
  }

  public String getGTVText()
  {
    return iGTV.getText().toString();
  }

  private void setGTV(TextView gTV)
  {
    iGTV = gTV;
  }

  public TextView getATV()
  {
    return iATV;
  }

  public String getATVText()
  {
    return iATV.getText().toString();
  }

  private void setATV(TextView aTV)
  {
    iATV = aTV;
  }

  public TextView getVTV()
  {
    return iVTV;
  }

  public String getVTVText()
  {
    return iVTV.getText().toString();
  }

  private void setVTV(TextView vTV)
  {
    iVTV = vTV;
  }

  public MCRDoc getSelectedArtifact()
  {
    return iSelectedArtifact;
  }

  private void setSelectedArtifact(MCRDoc selectedArtifact)
  {
    iSelectedArtifact = selectedArtifact;
  }

}
