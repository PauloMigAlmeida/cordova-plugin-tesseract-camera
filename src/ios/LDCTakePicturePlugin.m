//
//  LDCTakePicturePlugin.m
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/27/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import "LDCTakePicturePlugin.h"

@interface LDCTakePicturePlugin()

@property(strong,nonatomic) NSString* callbackId;
@property(strong,nonatomic) LDCTakePictureViewController* takePictureViewController;

@end

@implementation LDCTakePicturePlugin

-(void)takePicture:(CDVInvokedUrlCommand *) command
{

    self.callbackId = command.callbackId;
    
    self.takePictureViewController = [[LDCTakePictureViewController alloc]init];
    self.takePictureViewController.delegate = self;
    [self.viewController presentViewController:self.takePictureViewController animated:YES completion:nil];
    
}

#pragma mark - LDCTakePictureViewControllerDelegate methods

-(void)snapStillImageHasBeenTaken:(UIImage *)image{
    
    //Base64 encoding
    NSString* imageBase64 = [image base64StringFromImage];
    
    //Building plugin result
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:imageBase64];
    
    //Sending result to javascript
    [self commonCallbackResponse:pluginResult];
}

-(void) closeButtonHasBeenTouched{
    //Sending result to javascript
    [self commonCallbackResponse:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK ]];
}


-(void) commonCallbackResponse:(CDVPluginResult*) pluginResult{
    //Sending result to javascript after closing UIViewController
    [self.takePictureViewController dismissViewControllerAnimated:YES completion:^{
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    }];
}
@end
