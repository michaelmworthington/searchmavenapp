package net.worthington.android.maven.search;

import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

public class SearchResults extends ListActivity
{
  @Override
  protected void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    setContentView(R.layout.search_results);

    setListAdapter(new MyAdapter(this, android.R.layout.simple_list_item_1, R.id.groupIdTextView,
                                 getResources().getStringArray(R.array.sample_search_results)));
  }

  private class MyAdapter extends ArrayAdapter<String>
  {

    public MyAdapter(Context pContext, int pResource, int pTextViewResourceId, String[] pObjects)
    {
      super(pContext, pResource, pTextViewResourceId, pObjects);
    }

    @Override
    public View getView(int pPosition, View pConvertView, ViewGroup pParent)
    {
      LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
      View row = inflater.inflate(R.layout.search_results_item, pParent, false);
      TextView gtv = (TextView) row.findViewById(R.id.groupIdTextView);
      TextView atv = (TextView) row.findViewById(R.id.artifactIdTextView);

      String[] sampleResults = getResources().getStringArray(R.array.sample_search_results);
      
      String[] sa = sampleResults[pPosition].split(":");

      gtv.setText(sa[0]);
      atv.setText(sa[1]);

      return row;
    }

  }

}
