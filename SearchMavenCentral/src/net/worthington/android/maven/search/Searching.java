package net.worthington.android.maven.search;

import net.worthington.android.maven.search.restletapi.MavenCentralRestAPI;
import net.worthington.android.maven.search.restletapi.MyAndroidConnectivity;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class Searching extends Activity implements OnClickListener
{
  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.searching);

    TextView tv = (TextView) findViewById(R.id.textView1);
    tv.setText("Searching for: " + getIntent().getExtras().getString("searchvalue"));

    Button cb = (Button) findViewById(R.id.cancelButton);
    cb.setOnClickListener(this);

    Button fb = (Button) findViewById(R.id.finishButton);
    fb.setOnClickListener(this);
  }

  @Override
  protected void onResume()
  {
    Log.d("net.worthington", "My On Resume Called....Calling Super");
    super.onResume();
    Log.d("net.worthington", "Super On Resume done....Making the Rest Call");
    
    MyAndroidConnectivity.checkConnectivity(this);

    MavenCentralRestAPI mcr = new MavenCentralRestAPI();
    MCRResponse searchResults = mcr.search(getIntent().getExtras().getString("searchvalue"));
    
    Intent intent = new Intent(Searching.this, RealSearchResults.class);
    intent.putExtra("searchResults", searchResults);
    startActivity(intent);

    Log.d("net.worthington", "REST Call Returned");
  }
  
  @Override
  public void onClick(View v)
  {
    if (v.getId() == R.id.cancelButton)
    {
      Log.d("net.worthington", "Cancel Button was clicked. Go Back to Main.");
      startActivity(new Intent(Searching.this, Main.class));
    }
    else if (v.getId() == R.id.finishButton)
    {
      Log.d("net.worthington", "Finish Button was clicked. Go to Search Results.");
      startActivity(new Intent(Searching.this, SearchResults.class));
    }
    else
    {
      Log.d("net.worthington", "Another field was clicked");
    }
  }

}
