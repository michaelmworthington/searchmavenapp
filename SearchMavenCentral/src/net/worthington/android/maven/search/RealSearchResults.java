package net.worthington.android.maven.search;

import java.util.List;

import net.worthington.android.maven.search.restletapi.dao.MCRDoc;
import net.worthington.android.maven.search.restletapi.dao.MCRResponse;
import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

public class RealSearchResults extends ListActivity
{
  @Override
  protected void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    setContentView(R.layout.real_search_results);

    MCRResponse searchResults = (MCRResponse) getIntent().getExtras().getSerializable("searchResults");
    
    if ( searchResults != null )
    {
    TextView tv = (TextView) findViewById(R.id.textView1);
    tv.setText(searchResults.getNumFound() + " Search Results:");
    
    setListAdapter(new MyAdapter(this, 
                                 android.R.layout.simple_list_item_1, 
                                 R.id.groupIdTextView,
                                 searchResults.getDocs()));
    }
    else
    {
      TextView tv = (TextView) findViewById(R.id.textView1);
      tv.setText("Search Results were null - check log");
    }
  }

  private class MyAdapter extends ArrayAdapter<MCRDoc>
  {

    public MyAdapter(Context pContext, int pResource, int pTextViewResourceId, List<MCRDoc> pObjects)
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

      MCRResponse searchResults = (MCRResponse) getIntent().getExtras().getSerializable("searchResults");
      List<MCRDoc> sampleResults = searchResults.getDocs();
      
      MCRDoc sa = sampleResults.get(pPosition);

      gtv.setText(sa.getG());
      atv.setText(sa.getA());

      return row;
    }

  }

}
