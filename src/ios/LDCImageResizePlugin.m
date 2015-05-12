//
//  LDCImageResizePlugin.m
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

#import "LDCImageResizePlugin.h"

@implementation LDCImageResizePlugin

-(void)resizeImageByFactor:(CDVInvokedUrlCommand *)command
{
    NSString* imageData = (NSString*)[command.arguments objectAtIndex:0];
    double factorHorizontalAxis = [(NSNumber*)[command.arguments objectAtIndex:1] doubleValue];
    double factorVerticalAxis = [(NSNumber*)[command.arguments objectAtIndex:2] doubleValue];
    
    __weak LDCImageResizePlugin* weakSelf = self;
    
    [self.commandDelegate runInBackground:^{
        
        LDCOpenCVIntegration* opencv  = [[LDCOpenCVIntegration alloc]init];
        
        UIImage* imageToBeRecognized = [imageData imageFromBase64String];
        
        imageToBeRecognized = [opencv resize:imageToBeRecognized AndFactorX:factorHorizontalAxis AndFactorY:factorVerticalAxis];
        
        
        // Convert NSString to Base 64
        NSString *imageBase64 = [imageToBeRecognized base64StringFromImage];
        
        //Send back to JS interface
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:imageBase64];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];
    
}

-(void)resizeImageKeepAspectRatio:(CDVInvokedUrlCommand *)command
{
    NSString* imageData = (NSString*)[command.arguments objectAtIndex:0];
    double targetWidth = [(NSNumber*)[command.arguments objectAtIndex:1] doubleValue];
    
    __weak LDCImageResizePlugin* weakSelf = self;
    
    [self.commandDelegate runInBackground:^{
        
        LDCOpenCVIntegration* opencv  = [[LDCOpenCVIntegration alloc]init];
        
        UIImage* imageToBeRecognized = [imageData imageFromBase64String];
        
        imageToBeRecognized = [opencv resize:imageToBeRecognized AndTargetWidth:targetWidth];
        
        
        // Convert NSString to Base 64
        NSString *imageBase64 = [imageToBeRecognized base64StringFromImage];
        
        //Send back to JS interface
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:imageBase64];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }];
    
}


@end
