//
//  LDCFoundationCameraView.h
//  InstaGraacCamera
//
//  Created by Paulo Miguel Almeida on 1/21/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import <UIKit/UIKit.h>

//Libraries
#import <AVFoundation/AVFoundation.h>

@interface LDCFoundationCameraView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
