var exec = cordova.require('cordova/exec');

exports.recognize = function () {
    exec(function(){console.log('Success');}, null, 'LDCTesseractImageRecognizerPlugin', 'recognizeImage', ['image_sample.jpg']);
};
