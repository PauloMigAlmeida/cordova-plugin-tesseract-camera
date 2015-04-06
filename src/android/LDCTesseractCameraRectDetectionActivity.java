package com.github.pauloubuntu.tesseractcamera;

import java.io.ByteArrayOutputStream;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageFormat;
import android.graphics.Rect;
import android.graphics.YuvImage;
import android.hardware.Camera;
import android.os.Bundle;
import android.util.Log;
import android.widget.ImageView;
import br.com.loducca.R;

public class LDCTesseractCameraRectDetectionActivity extends Activity implements Camera.PreviewCallback {
	private CameraPreview cameraPreview;
	private ImageView imagePreview;

	private LDCTesseractCameraOpenCVIntegration cameraOpenCVIntegration;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		cameraOpenCVIntegration = new LDCTesseractCameraOpenCVIntegration();

		// Get components form layout
		this.cameraPreview = (CameraPreview) findViewById(R.id.camera);
		this.imagePreview = (ImageView) findViewById(R.id.imagePreview);

		cameraPreview.setPreviewCallback(this);
	}

	@Override
	public void onPreviewFrame(byte[] data, Camera camera) {
		if (camera.getParameters().getPreviewFormat() == ImageFormat.NV21) {
			// We only accept the NV21(YUV420) format.
//			cameraOpenCVIntegration.processRectDetector(this.cameraPreview.getmPreviewSize().width, this.cameraPreview.getmPreviewSize().height,
//					data, this.imagePreview);
			
			int width = this.cameraPreview.getmPreviewSize().width, height = this.cameraPreview.getmPreviewSize().height;
			
//			YuvImage yuv = new YuvImage(data, camera.getParameters().getPreviewFormat(), width, height, null);
//
//			ByteArrayOutputStream out = new ByteArrayOutputStream();
//		    yuv.compressToJpeg(new Rect(0, 0, width, height), 50, out);
//
//		    final Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);		
//			this.imagePreview.setImageBitmap(bitmap);
		    
			cameraOpenCVIntegration.processRectDetector(width, height, data, this.imagePreview);

		}

	}

}
