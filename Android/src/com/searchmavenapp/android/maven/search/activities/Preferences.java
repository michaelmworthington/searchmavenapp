package com.searchmavenapp.android.maven.search.activities;

import com.searchmavenapp.android.maven.search.R;
import android.os.Bundle;
import android.preference.PreferenceActivity;

public class Preferences extends PreferenceActivity
{
  @Override
  protected void onCreate(Bundle pSavedInstanceState)
  {
    super.onCreate(pSavedInstanceState);
    addPreferencesFromResource(R.xml.preferences);
  }
}
