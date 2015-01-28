//
//  LDCFoundationCameraViewPlugin.m
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/27/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import "LDCFoundationCameraViewPlugin.h"

@interface LDCFoundationCameraViewPlugin()

@property(strong,nonatomic) NSString* callbackId;

@end


@implementation LDCFoundationCameraViewPlugin

-(CDVPlugin *)initWithWebView:(UIWebView *)theWebView{
    self = (LDCFoundationCameraViewPlugin*)[super initWithWebView:theWebView];
    return self;
}

-(void)createCameraView:(CDVInvokedUrlCommand *) command
{
    /**
        Method largely based on devgeeks example of how to add a native view from a cordova plugin.
        https://github.com/devgeeks/VolumeSlider
     */
    self.callbackId = command.callbackId;
    NSArray* arguments = [command arguments];
    
    NSUInteger argc = [arguments count];
    
    if (argc < 4) { // at a minimum we need x origin, y origin and width...
        return;
    }
    
    if (self.cameraView) {
        return;  //already created, don't need to create it again
    }
    
    CGFloat originx,originy,width,height;
    
    originx = [[arguments objectAtIndex:0] floatValue];
    originy = [[arguments objectAtIndex:1] floatValue];
    width = [[arguments objectAtIndex:2] floatValue];
    height = [[arguments objectAtIndex:3] floatValue];

    CGRect cameraViewRect = CGRectMake(originx,originy,width,height);
    

    //Creating LDCFoundationCameraView instance
    self.cameraView = [[LDCFoundationCameraView alloc] initWithFrame:cameraViewRect];
    self.cameraView.backgroundColor = [UIColor blackColor];
    self.cameraView.delegate = self;
    
    //Creating Close Button
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 56, 56)];
    [btnClose setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseHandler) forControlEvents:UIControlEventTouchUpInside];

    //Adding `em to webview
    [self.webView.superview addSubview:self.cameraView];
    [self.webView.superview addSubview:btnClose];

    //Initializing AVFoundation
    [self.cameraView initializeCamera];

    
    
}

#pragma mark - Action methods

-(void) btnCloseHandler
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

#pragma mark - LDCFoundationCameraViewDelegate methods

-(void)snapStillImageHasBeenTaken:(UIImage *)image{
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:self.callbackId];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Picture taken" message:@"Worked dude" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
