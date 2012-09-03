package com.searchmavenapp.android.maven.search.constants;

import com.searchmavenapp.android.maven.search.KeyboardSearchEditorActionListener;

import android.app.Activity;
import android.graphics.Color;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.widget.EditText;

public class TextViewHelper
{
  public static EditText lookupEditTextAndSetListeners(Activity pActivity, int pEditTextResourceId, int pTargetDialogId)
  {
    EditText et = (EditText) pActivity.findViewById(pEditTextResourceId);
    et.setOnClickListener((OnClickListener) pActivity);
    et.setOnKeyListener((OnKeyListener) pActivity);
    // http://stackoverflow.com/questions/3205339/android-how-to-make-keyboard-enter-button-say-search-and-handle-its-click
    et.setOnEditorActionListener(new KeyboardSearchEditorActionListener(pActivity, pTargetDialogId));
    return et;
  }

  public static void clearTextView(EditText pEditText)
  {
    if ("Search".equals(pEditText.getText().toString()))
    {
      pEditText.setText("");
      pEditText.setTextColor(Color.BLACK);
    }
  }

}
