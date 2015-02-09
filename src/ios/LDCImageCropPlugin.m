//
//  LDCImageCropViewController.m
//
//  Version 0.0.1
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Paulo Miguel Almeida Rodenas <paulo.ubuntu@gmail.com>
//
//  Get the latest version from here:
//
//  https://github.com/pauloubuntu/cordova-plugin-tesseract-camera
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "LDCImageCropPlugin.h"

@interface LDCImageCropPlugin()

@property(strong,nonatomic) NSString* callbackId;

@end

@implementation LDCImageCropPlugin

-(void)cropImage:(CDVInvokedUrlCommand *)command
{
    self.callbackId = command.callbackId;
    
    NSString* imageData = (NSString*)[command.arguments objectAtIndex:0];
    
    //Base64 decoding
    UIImage* image = [imageData imageFromBase64String];
        
    //Open ViewController
    LDCImageCropViewController* vc = [[LDCImageCropViewController alloc] initWithImage:image];
    vc.delegate = self;
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - LDCImageCropViewControllerDelegate methods

-(void)didFinishCropping:(UIImage *)croppedImage{
    //Base64 encoding
    NSString* imageBase64 = [croppedImage base64StringFromImage];
    
    //Building plugin result
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:imageBase64];
    
    //Sending result to javascript
    [self commonCallbackResponse:pluginResult];
}

-(void)didCancel{
    //Sending result to javascript
    [self commonCallbackResponse:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK ]];
}

-(void) commonCallbackResponse:(CDVPluginResult*) pluginResult{
    //Sending result to javascript after closing UIViewController
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
