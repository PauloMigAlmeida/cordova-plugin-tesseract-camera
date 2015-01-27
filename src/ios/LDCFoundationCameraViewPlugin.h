//
//  LDCFoundationCameraViewPlugin.h
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/27/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import <UIKit/UIKit.h>

//Libraries
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

//Local Files
#import "LDCFoundationCameraView.h"

@interface LDCFoundationCameraViewPlugin : CDVPlugin

@property(nonatomic, retain) LDCFoundationCameraView* cameraView;

-(void)createCameraView:(CDVInvokedUrlCommand *) command;

@end
