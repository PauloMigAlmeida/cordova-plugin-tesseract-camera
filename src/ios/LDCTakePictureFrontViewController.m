//
//  LDCTakePictureFrontViewController.m
//  InstaGraacc
//
//  Created by Paulo Miguel Almeida on 2/21/15.
//
//

#import "LDCTakePictureFrontViewController.h"

@implementation LDCTakePictureFrontViewController

#pragma mark - Action methods

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.footerView.delegate = self;
    self.preferedPosition = AVCaptureDevicePositionFront;
    
}

-(void) snapStillImage{
    dispatch_async([self sessionQueue], ^{
        // Update the orientation on the still image output video connection before capturing.
        [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[self.cameraView layer] connection] videoOrientation]];
        
        // Flash set to Auto for Still Capture
        [self setFlashMode:AVCaptureFlashModeAuto forDevice:[[self videoDeviceInput] device]];
        
        // Capture a still image.
        [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            if (imageDataSampleBuffer)
            {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                
                [[self session] stopRunning];
                
                if(self.delegate){
                    [self.delegate snapStillImageHasBeenTaken:image];
                }
            }
        }];
    });
    
}

#pragma mark - LDCFoundationCameraFooterViewDelegate methods

-(void)snapStillImageCaptureButtonTouched{
    [self snapStillImage];
}

@end
