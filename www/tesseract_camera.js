var exec = cordova.require('cordova/exec');

exports.recognize = function (imageSourceURL, charWhiteList, callbackSuccess, callbackFailure) {
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageRecognizer', 'recognizeImage', [imageSourceURL, charWhiteList]);
};

exports.createCameraView = function (originX, originY, width, height, callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractCamera', 'createCameraView', [originX, originY, width, height]);
};
