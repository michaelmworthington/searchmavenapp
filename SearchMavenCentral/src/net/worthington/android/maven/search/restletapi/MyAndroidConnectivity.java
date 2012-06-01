package net.worthington.android.maven.search.restletapi;

import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;

public class MyAndroidConnectivity
{
  public static void checkConnectivity(Activity pThis)
  {
    boolean haveConnectedWifi = false;
    boolean haveConnectedMobile = false;

    ConnectivityManager cm = (ConnectivityManager) pThis.getSystemService(Context.CONNECTIVITY_SERVICE);
    NetworkInfo[] netInfo = cm.getAllNetworkInfo();
    for (NetworkInfo ni : netInfo)
    {
      if (ni.getTypeName().equalsIgnoreCase("WIFI"))
      {
        if (ni.isConnectedOrConnecting())
        {
          haveConnectedWifi = true;
        }
      }
      if (ni.getTypeName().equalsIgnoreCase("MOBILE"))
      {
        if (ni.isConnectedOrConnecting())
        {
          haveConnectedMobile = true;
        }
      }
    }

    Log.d("net.worthington", "Is Wifi Connected?: " + haveConnectedWifi);
    Log.d("net.worthington", "Is Mobile Connected?: " + haveConnectedMobile);
  }

}
