var exec = cordova.require('cordova/exec');

exports.recognize = function (imageData, charWhiteList, callbackSuccess, callbackFailure) {
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageRecognizer', 'recognizeImage', [imageData, charWhiteList]);
};

exports.realtimeRecognizerStart = function(charWhiteList, callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractRealTimeRecognizer', 'start', [charWhiteList]);
}

exports.realtimeRecognizeClose = function(callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractRealTimeRecognizer', 'stop', []);
};

exports.takePicture = function (callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractCamera', 'takePicture', []);
};

exports.cropImage = function (imageData,callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageCrop', 'cropImage', [imageData]);
};
