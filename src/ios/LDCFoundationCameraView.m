//
//  LDCFoundationCameraView.m
//  InstaGraacCamera
//
//  Created by Paulo Miguel Almeida on 1/21/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import "LDCFoundationCameraView.h"

@implementation LDCFoundationCameraView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
    [(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
