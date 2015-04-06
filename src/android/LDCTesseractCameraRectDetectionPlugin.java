package com.github.pauloubuntu.tesseractcamera;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

public class LDCTesseractCameraRectDetectionPlugin extends CordovaPlugin{
	
	@Override
	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {
		
		if(action.equals("takePicture")){
			this.takePicture(callbackContext);
			return true;
		}
		return false;
	}

	private void takePicture(CallbackContext callbackContext) {
		Context context = this.cordova.getActivity().getApplicationContext();
		Intent intent = new Intent(context, LDCTesseractCameraRectDetectionActivity.class);
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		context.startActivity(intent);		
	}

}
