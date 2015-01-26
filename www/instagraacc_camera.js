var exec = cordova.require('cordova/exec');

exports.recognize = function () {
    exec(function(){console.log('Success');}, function(){console.log('Fail');}, 'CordovaTesseractCamera', 'recognizeImage', ['image_sample.jpg']);
};
