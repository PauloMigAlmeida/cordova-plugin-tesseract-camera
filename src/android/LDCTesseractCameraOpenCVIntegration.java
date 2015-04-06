package com.github.pauloubuntu.tesseractcamera;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.ImageView;

public class LDCTesseractCameraOpenCVIntegration {

	private boolean processing;
	private Handler handler;
	
	static {
		System.loadLibrary("ImageProcessing");
	}
		
	public LDCTesseractCameraOpenCVIntegration() {
		this.handler = new Handler(Looper.getMainLooper());
	}
	
	public native boolean ImageProcessing(int width, int height, byte[] NV21FrameData, int[] pixels);
	public native boolean rectRecognizing(int width, int height, byte[] NV21FrameData, int[] pixels);
	
	public void processCannyEdgeDetector(final int width,final  int height,final  byte[] NV21FrameData,final  ImageView imageView){
		if(!processing){
			processing = !processing;
			this.handler.post(new Runnable() {
				
				@Override
				public void run() {
							int[] pixelsOut = new int[width * height];	
							Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
							
							ImageProcessing(width, height, NV21FrameData, pixelsOut);
							
							bitmap.setPixels(pixelsOut, 0, width, 0, 0, width, height);
							imageView.setImageBitmap(bitmap);
							processing = false;
				}
			});
		}
	}
	
	public void processRectDetector(final int width,final  int height,final  byte[] NV21FrameData,final  ImageView imageView){
		if(!processing){
			processing = !processing;
			this.handler.post(new Runnable() {
				
				@Override
				public void run() {
							int[] pixelsOut = new int[width * height];	
							Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
							
							rectRecognizing(width, height, NV21FrameData, pixelsOut);
//							Log.i("PROCESS", "pixelsOut.length: " + pixelsOut.length);
							bitmap.setPixels(pixelsOut, 0, width, 0, 0, width, height);							
							imageView.setImageBitmap(bitmap);
							processing = false;
				}
			});
		}
	}
	
	
}
