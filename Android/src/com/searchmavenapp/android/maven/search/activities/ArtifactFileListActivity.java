/**
 * 
 */
package com.searchmavenapp.android.maven.search.activities;

import com.searchmavenapp.android.maven.search.R;
import android.app.ListActivity;
import android.os.Bundle;
import android.widget.ArrayAdapter;

/**
 * @author Michael
 * 
 */
public class ArtifactFileListActivity extends ListActivity
{
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);

    // Use an existing ListAdapter that will map an array
    // of strings to TextViews
    setListAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, getResources().getStringArray(R.array.sample_log4j_file_list)));
    getListView().setTextFilterEnabled(true);
  }

}
