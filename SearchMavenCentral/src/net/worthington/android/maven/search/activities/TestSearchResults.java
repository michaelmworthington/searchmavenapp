package net.worthington.android.maven.search.activities;

import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import net.worthington.android.maven.search.R;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

public class TestSearchResults extends Activity
{
  // All variables
  XMLParser                          parser;
  Document                           doc;
  String                             xml;
  ListView                           lv;
  MyListViewAdapter                  adapter;
  ArrayList<HashMap<String, String>> menuItems;
  ProgressDialog                     pDialog;

  private String                     URL          = "http://api.androidhive.info/list_paging/?page=1";

  // XML node keys
  static final String                KEY_ITEM     = "item";                                           // parent node
  static final String                KEY_ID       = "id";
  static final String                KEY_NAME     = "name";

  // Flag for current page
  int                                current_page = 1;

  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.test_search_results);

    lv = (ListView) findViewById(R.id.list);

    menuItems = new ArrayList<HashMap<String, String>>();

    parser = new XMLParser();
    xml = parser.getXmlFromUrl(URL); // getting XML
    doc = parser.getDomElement(xml); // getting DOM element

    NodeList nl = doc.getElementsByTagName(KEY_ITEM);
    // looping through all item nodes <item>
    for (int i = 0; i < nl.getLength(); i++)
    {
      // creating new HashMap
      HashMap<String, String> map = new HashMap<String, String>();
      Element e = (Element) nl.item(i);
      // adding each child node to HashMap key => value
      map.put(KEY_ID, parser.getValue(e, KEY_ID)); // id not using any where
      map.put(KEY_NAME, parser.getValue(e, KEY_NAME));

      // adding HashList to ArrayList
      menuItems.add(map);
    }

    // LoadMore button
    Button btnLoadMore = new Button(this);
    btnLoadMore.setText("Load More");

    // Adding Load More button to lisview at bottom
    lv.addFooterView(btnLoadMore);

    // Getting adapter
    adapter = new MyListViewAdapter(this, menuItems);
    lv.setAdapter(adapter);

    btnLoadMore.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View arg0)
      {
        // Starting a new async task
        new LoadMoreListViewThread().execute();
      }
    });
  }

  private class MyListViewAdapter extends BaseAdapter
  {

    private Activity                           activity;
    private ArrayList<HashMap<String, String>> data;
    private LayoutInflater                     inflater = null;

    public MyListViewAdapter(Activity a, ArrayList<HashMap<String, String>> d)
    {
      activity = a;
      data = d;
      inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    public int getCount()
    {
      return data.size();
    }

    public Object getItem(int position)
    {
      return position;
    }

    public long getItemId(int position)
    {
      return position;
    }

    public View getView(int position, View convertView, ViewGroup parent)
    {
      View vi = convertView;
      if (convertView == null)
      {
        vi = inflater.inflate(R.layout.test_search_results_item, null);
      }

      TextView name = (TextView) vi.findViewById(R.id.name);

      HashMap<String, String> item = new HashMap<String, String>();
      item = data.get(position);

      // Setting all values in listview
      name.setText(item.get("name"));
      return vi;
    }
  }

  private class XMLParser
  {

    // constructor
    public XMLParser()
    {

    }

    /**
     * Getting XML from URL making HTTP request
     * 
     * @param url
     *          string
     * */
    public String getXmlFromUrl(String url)
    {
      String xml = null;

      try
      {
        // defaultHttpClient
        DefaultHttpClient httpClient = new DefaultHttpClient();
        HttpPost httpPost = new HttpPost(url);

        HttpResponse httpResponse = httpClient.execute(httpPost);
        HttpEntity httpEntity = httpResponse.getEntity();
        xml = EntityUtils.toString(httpEntity);

      }
      catch (UnsupportedEncodingException e)
      {
        e.printStackTrace();
      }
      catch (ClientProtocolException e)
      {
        e.printStackTrace();
      }
      catch (IOException e)
      {
        e.printStackTrace();
      }
      // return XML
      return xml;
    }

    /**
     * Getting XML DOM element
     * 
     * @param XML
     *          string
     * */
    public Document getDomElement(String xml)
    {
      Document doc = null;
      DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
      try
      {

        DocumentBuilder db = dbf.newDocumentBuilder();

        InputSource is = new InputSource();
        is.setCharacterStream(new StringReader(xml));
        doc = db.parse(is);

      }
      catch (ParserConfigurationException e)
      {
        Log.e("Error: ", e.getMessage());
        return null;
      }
      catch (SAXException e)
      {
        Log.e("Error: ", e.getMessage());
        return null;
      }
      catch (IOException e)
      {
        Log.e("Error: ", e.getMessage());
        return null;
      }

      return doc;
    }

    /**
     * Getting node value
     * 
     * @param elem
     *          element
     */
    public final String getElementValue(Node elem)
    {
      Node child;
      if (elem != null)
      {
        if (elem.hasChildNodes())
        {
          for (child = elem.getFirstChild(); child != null; child = child.getNextSibling())
          {
            if (child.getNodeType() == Node.TEXT_NODE)
            {
              return child.getNodeValue();
            }
          }
        }
      }
      return "";
    }

    /**
     * Getting node value
     * 
     * @param Element
     *          node
     * @param key
     *          string
     * */
    public String getValue(Element item, String str)
    {
      NodeList n = item.getElementsByTagName(str);
      return this.getElementValue(n.item(0));
    }
  }

  private class LoadMoreListViewThread extends AsyncTask<Void, Void, Void>
  {

    @Override
    protected void onPreExecute()
    {
      // Showing progress dialog before sending http request
      pDialog = new ProgressDialog(TestSearchResults.this);
      pDialog.setMessage("Please wait..");
      pDialog.setIndeterminate(true);
      pDialog.setCancelable(false);
      pDialog.show();
    }

    protected Void doInBackground(Void... unused)
    {
      runOnUiThread(new Runnable() {
        public void run()
        {
          // increment current page
          current_page += 1;

          // Next page request
          URL = "http://api.androidhive.info/list_paging/?page=" + current_page;

          xml = parser.getXmlFromUrl(URL); // getting XML
          doc = parser.getDomElement(xml); // getting DOM element

          NodeList nl = doc.getElementsByTagName(KEY_ITEM);
          // looping through all item nodes <item>
          for (int i = 0; i < nl.getLength(); i++)
          {
            // creating new HashMap
            HashMap<String, String> map = new HashMap<String, String>();
            Element e = (Element) nl.item(i);

            // adding each child node to HashMap key => value
            map.put(KEY_ID, parser.getValue(e, KEY_ID));
            map.put(KEY_NAME, parser.getValue(e, KEY_NAME));

            // adding HashList to ArrayList
            menuItems.add(map);
          }

          // get listview current position - used to maintain scroll position
          int currentPosition = lv.getFirstVisiblePosition();

          // Appending new data to menuItems ArrayList
          adapter = new MyListViewAdapter(TestSearchResults.this, menuItems);

          // Setting new scroll position
          lv.setSelectionFromTop(currentPosition + 1, 0);
        }
      });
      return (null);
    }

    protected void onPostExecute(Void unused)
    {
      // closing progress dialog
      pDialog.dismiss();
    }
  }
}
