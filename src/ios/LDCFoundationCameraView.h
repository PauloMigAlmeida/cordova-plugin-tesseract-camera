//
//  LDCFoundationCameraView.h
//  InstaGraacCamera
//
//  Created by Paulo Miguel Almeida on 1/21/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import <UIKit/UIKit.h>

//Libraries
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

//Custom Components
#import "LDCFoundationCameraFooterView.h"

@protocol LDCFoundationCameraViewDelegate <NSObject>

-(void) snapStillImageHasBeenTaken:(UIImage*) image;

@end

@interface LDCFoundationCameraView : UIView<LDCFoundationCameraFooterViewDelegate>

@property(nonatomic, retain) id<LDCFoundationCameraViewDelegate> delegate;

-(void) initializeCamera;
-(void) snapStillImage;

@end
