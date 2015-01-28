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

//Custom componentes
#import "LDCFoundationCameraView.h"
#import "LDCFoundationCameraFooterView.h"

@interface LDCFoundationCameraViewPlugin : CDVPlugin<LDCFoundationCameraViewDelegate,LDCFoundationCameraFooterViewDelegate>

@property(nonatomic, retain) LDCFoundationCameraView* cameraView;
@property(nonatomic, retain) LDCFoundationCameraFooterView* footerView;

-(void)createCameraView:(CDVInvokedUrlCommand *) command;

@end
