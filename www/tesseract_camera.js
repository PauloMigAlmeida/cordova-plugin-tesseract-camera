var exec = cordova.require('cordova/exec');

exports.CameraPreferedPosition = {
	BACK_CAMERA: 1,
    FRONT_CAMERA: 2,
    CROP_MARKERS: 4	
};

var xor = function (a ,b) {
  return ( a || b ) && !( a && b );
};

exports.recognize = function (imageData, charWhiteList, callbackSuccess, callbackFailure) {
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageRecognizer', 'recognizeImage', [imageData, charWhiteList]);
};

exports.recognizeRect = function(callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractCameraRectDetection', 'takePicture', []);
}

exports.takePicture = function (preferedPosition, callbackSuccess, callbackFailure){
	var _cameraPreferedPosition = null;
	var _cropMarkers = false;
	
	if(xor(((preferedPosition & exports.CameraPreferedPosition.BACK_CAMERA) == exports.CameraPreferedPosition.BACK_CAMERA),((preferedPosition & exports.CameraPreferedPosition.FRONT_CAMERA)  == exports.CameraPreferedPosition.FRONT_CAMERA))){
	    if (preferedPosition & exports.CameraPreferedPosition.BACK_CAMERA){
			_cameraPreferedPosition = 'back';
	        console.log("BACK_CAMERA selected");
	    }
	    if (preferedPosition & exports.CameraPreferedPosition.FRONT_CAMERA){
	        _cameraPreferedPosition = 'front';
			console.log("FRONT_CAMERA selected");
	    }
	    if (preferedPosition & exports.CameraPreferedPosition.CROP_MARKERS){
			_cropMarkers = true;
	        console.log("CROP_MARKERS selected");
	    }
	    else{
	        console.log("You haven't set any value on preferedPosition variable. I'm going to use the default ones.");
	    }
	}else{
	    console.log('You just can\'t use both cameras at the same time.');
	}
	
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractCamera', 'takePicture', [_cameraPreferedPosition, _cropMarkers]);
};

exports.cropImage = function (imageData,callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageCrop', 'cropImage', [imageData]);
};

exports.resizeImageByFactor = function (imageData, factorHorizontalAxis, factorVerticalAxis,callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageResize', 'resizeImageByFactor', [imageData, factorHorizontalAxis, factorVerticalAxis]);
};

exports.resizeImageKeepAspectRatio = function (imageData, targetWidth, callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageResize', 'resizeImageKeepAspectRatio', [imageData, targetWidth]);
};
