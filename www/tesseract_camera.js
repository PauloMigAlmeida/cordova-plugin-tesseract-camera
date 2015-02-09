var exec = cordova.require('cordova/exec');

exports.image.recognize = function (imageData, charWhiteList, callbackSuccess, callbackFailure) {
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageRecognizer', 'recognizeImage', [imageData, charWhiteList]);
};

exports.realtime.recognize.start = function(charWhiteList, callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractRealTimeRecognizer', 'start', [charWhiteList]);
}

exports.realtime.recognize.close = function(callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractRealTimeRecognizer', 'stop', []);
};

exports.takePicture = function (callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractCamera', 'takePicture', []);
};

exports.image.cropImage = function (imageData,callbackSuccess, callbackFailure){
    exec(callbackSuccess, callbackFailure, 'CordovaTesseractImageCrop', 'cropImage', [imageData]);
};
