
package com.kevinresol.react_native_default_preference;

import android.content.Context;
import android.content.SharedPreferences;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import java.util.Map;

public class RNDefaultPreferenceModule extends ReactContextBaseJavaModule {
  private String preferencesName = "react-native";

  private final ReactApplicationContext reactContext;

  public RNDefaultPreferenceModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNDefaultPreference";
  }

  @ReactMethod
  public void get(String preferenceName, String key, Promise promise) {
    promise.resolve(getPreferences(preferenceName).getString(key, null));
  }

  @ReactMethod
  public void getInt(String preferenceName, String key, Promise promise) {
    promise.resolve(getPreferences(preferenceName).getInt(key, 1));
  }

  @ReactMethod
  public void set(String preferenceName, String key, String value, Promise promise) {
    getEditor(preferenceName).putString(key, value).commit();
    promise.resolve(null);
  }

  @ReactMethod
  public void clear(String preferenceName, String key, Promise promise) {
    getEditor(preferenceName).remove(key).commit();
    promise.resolve(null);
  }

  @ReactMethod
  public void getMultiple(String preferenceName, ReadableArray keys, Promise promise) {
    WritableArray result = Arguments.createArray();
    for(int i = 0; i < keys.size(); i++) {
      result.pushString(getPreferences(preferenceName).getString(keys.getString(i), null));
    }
    promise.resolve(result);
  }

  @ReactMethod
  public void setMultiple(String preferenceName, ReadableMap data, Promise promise) {
    SharedPreferences.Editor editor = getEditor(preferenceName);
    ReadableMapKeySetIterator iter = data.keySetIterator();
    while(iter.hasNextKey()) {
      String key = iter.nextKey();
      editor.putString(key, data.getString(key)).commit();
    }
    promise.resolve(null);
  }

  @ReactMethod
  public void clearMultiple(String preferenceName, ReadableArray keys, Promise promise) {
    SharedPreferences.Editor editor = getEditor(preferenceName);
    for(int i = 0; i < keys.size(); i++) {
      editor.remove(keys.getString(i));
    }
    editor.commit();
    promise.resolve(null);
  }

  @ReactMethod
  public void getAll(String preferenceName, Promise promise) {
    WritableMap result = Arguments.createMap();
    Map<String, ?> allEntries = getPreferences(preferenceName).getAll();
    for (Map.Entry<String, ?> entry : allEntries.entrySet()) {
      result.putString(entry.getKey(), entry.getValue().toString());
    }
    promise.resolve(result);
  }

  @ReactMethod
  public void clearAll(String preferenceName, Promise promise) {
    SharedPreferences.Editor editor = getEditor(preferenceName);
    Map<String, ?> allEntries = getPreferences(preferenceName).getAll();
    for (Map.Entry<String, ?> entry : allEntries.entrySet()) {
      editor.remove(entry.getKey());
    }
    editor.commit();
    promise.resolve(null);
  }

  private SharedPreferences getPreferences(String preferenceName) {
    return getReactApplicationContext().getSharedPreferences(preferenceName, Context.MODE_PRIVATE);
  }
  private SharedPreferences.Editor getEditor(String preferenceName) {
    return getPreferences(preferenceName).edit();
  }
}
