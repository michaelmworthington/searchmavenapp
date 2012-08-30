package com.searchmavenapp.android.maven.search;

import com.searchmavenapp.android.maven.search.constants.Constants;

import android.app.Activity;
import android.util.Log;
import android.view.KeyEvent;
import android.view.inputmethod.EditorInfo;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;

// http://stackoverflow.com/questions/3205339/android-how-to-make-keyboard-enter-button-say-search-and-handle-its-click
public class KeyboardSearchEditorActionListener implements OnEditorActionListener
{
  private Activity iActivity;
  private int iTargetDialogId;
  
  public KeyboardSearchEditorActionListener(Activity pActivity, int pTargetDialogId)
  {
    iActivity = pActivity;
    iTargetDialogId = pTargetDialogId;
  }
  

  @Override
  public boolean onEditorAction(TextView pV, int pActionId, KeyEvent pEvent)
  {
    Log.d(Constants.LOG_TAG, "Text View editor action: " + pActionId);
    if (pActionId == EditorInfo.IME_ACTION_SEARCH)
    {
      Log.d(Constants.LOG_TAG, "Call Show Dialog");
      
      iActivity.showDialog(iTargetDialogId);
      return true;
    }
    return false;
  }
}
