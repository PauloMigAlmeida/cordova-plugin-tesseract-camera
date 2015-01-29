var exec = cordova.require('cordova/exec');

exports.recognize = function (imageData, charWhiteList, callbackSuccess, callbackFailure) {
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageRecognizer', 'recognizeImage', [imageData, charWhiteList]);
};

exports.createCameraView = function (originX, originY, width, height, callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractCamera', 'createCameraView', [originX, originY, width, height]);
};
