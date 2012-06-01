package net.worthington.android.maven.search;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageButton;

public class Main extends Activity implements OnClickListener
{
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
      EditText et = (EditText) findViewById(R.id.searchEditText);
      Intent intent = new Intent(Main.this, Searching.class);
      intent.putExtra("searchvalue", et.getText().toString());
      startActivity(intent);
    }
    else
    {
      Log.d("net.worthington", "Another field was clicked");
    }
  }
}