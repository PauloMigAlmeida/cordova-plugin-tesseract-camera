var exec = cordova.require('cordova/exec');

exports.recognize = function (imageSourceURL, charWhiteList, callbackSuccess, callbackFailure) {
    exec(function(){callbackSuccess();}, function(){callbackFailure();}, 'CordovaTesseractCamera', 'recognizeImage', [imageSourceURL, charWhiteList]);
};
