//
//  LDCTakePictureViewController.m
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

#import "LDCTakePictureViewController.h"

@interface LDCTakePictureViewController()

@property(nonatomic, retain) UIImageView* cornerUpperLeft;
@property(nonatomic, retain) UIImageView* cornerUpperRight;
@property(nonatomic, retain) UIImageView* cornerBottomLeft;
@property(nonatomic, retain) UIImageView* cornerBottomRight;

@end

#define CORNER_MARKER_PADDING_START_PERC 5.0
#define CORNER_MARKER_DEFAULT_HEIGHT_PERC 8.0
#define CORNER_MARKER_DEFAULT_WIDTH_PERC 8.0

@implementation LDCTakePictureViewController

#pragma mark - Action methods

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.preferedPosition = AVCaptureDevicePositionBack;
    
    //Creating Close Button
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 56, 56)];
    [btnClose setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    //Add LDCFoundationCameraFooterView
    CGRect cameraFooterRect = CGRectMake(
                                         self.view.frame.origin.x,
                                         self.view.frame.size.height - FOOTER_DEFAULT_HEIGHT,
                                         self.view.frame.size.width,
                                         FOOTER_DEFAULT_HEIGHT
                                         );
    LDCFoundationCameraFooterView* footerView = [[LDCFoundationCameraFooterView alloc] initWithFrame:cameraFooterRect];
    footerView.delegate = self;
    [self.view addSubview:footerView];
    
    //Adding Corner Markers
    CGRect usableArea = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - FOOTER_DEFAULT_HEIGHT);
    CGSize defaultCornerSize = CGSizeMake(64, 55);
    
	self.cornerUpperLeft = [[UIImageView alloc] initWithFrame:CGRectMake(
																		 (usableArea.size.width * (CORNER_MARKER_DEFAULT_WIDTH_PERC / 100)),
																		 (usableArea.size.height * (CORNER_MARKER_DEFAULT_HEIGHT_PERC / 100)) + (usableArea.size.height * (CORNER_MARKER_PADDING_START_PERC / 100))+15,
																		 defaultCornerSize.width,
																		 defaultCornerSize.height
																		 )];
	self.cornerUpperLeft.image = [UIImage imageNamed:@"corner_upper_left.png"];
	self.cornerUpperLeft.backgroundColor = [UIColor clearColor];
	
	self.cornerUpperRight = [[UIImageView alloc] initWithFrame:CGRectMake(
																		  (usableArea.size.width * (1 - (CORNER_MARKER_DEFAULT_WIDTH_PERC / 100))) - defaultCornerSize.width,
																		  (usableArea.size.height * (CORNER_MARKER_DEFAULT_HEIGHT_PERC / 100)) + (usableArea.size.height * (CORNER_MARKER_PADDING_START_PERC / 100)) +15,
																		  defaultCornerSize.width,
																		  defaultCornerSize.height
																		  )];
	self.cornerUpperRight.image = [UIImage imageNamed:@"corner_upper_right.png"];
	self.cornerUpperRight.backgroundColor = [UIColor clearColor];
	
	self.cornerBottomLeft = [[UIImageView alloc] initWithFrame:CGRectMake(
																		  (usableArea.size.width * (CORNER_MARKER_DEFAULT_WIDTH_PERC / 100)),
																		  (usableArea.size.height * (1 - (CORNER_MARKER_DEFAULT_HEIGHT_PERC / 100))) - defaultCornerSize.height +30,
																		  defaultCornerSize.width,
																		  defaultCornerSize.height
																		  )];
	self.cornerBottomLeft.image = [UIImage imageNamed:@"corner_bottom_left.png"];
	self.cornerBottomLeft.backgroundColor = [UIColor clearColor];
	
	self.cornerBottomRight = [[UIImageView alloc] initWithFrame:CGRectMake(
																		   (usableArea.size.width * (1 - (CORNER_MARKER_DEFAULT_WIDTH_PERC / 100))) - defaultCornerSize.width,
																		   (usableArea.size.height * (1 - (CORNER_MARKER_DEFAULT_HEIGHT_PERC / 100))) - defaultCornerSize.height +30,
																		   defaultCornerSize.width,
																		   defaultCornerSize.height
																		   )];
	self.cornerBottomRight.image = [UIImage imageNamed:@"corner_bottom_right.png"];
	self.cornerBottomRight.backgroundColor = [UIColor clearColor];

	
    [self.view addSubview:self.cornerUpperLeft];
    [self.view addSubview:self.cornerUpperRight];
    [self.view addSubview:self.cornerBottomLeft];
    [self.view addSubview:self.cornerBottomRight];

}



-(UIImage*) cropImageWithinBounds:(UIImage*) image{
    CGSize usableArea = CGSizeMake(
                                   image.size.width,
                                   ((self.view.frame.size.height - FOOTER_DEFAULT_HEIGHT) / self.view.frame.size.height) * image.size.height
                                   );
	
    CGFloat x_crop = usableArea.width - (usableArea.width * (1.0 - (CORNER_MARKER_DEFAULT_WIDTH_PERC / 100))) ;
    CGFloat y_crop = usableArea.height - (usableArea.height * ( 1.0 - ((CORNER_MARKER_DEFAULT_HEIGHT_PERC + CORNER_MARKER_PADDING_START_PERC) / 100 )));
    CGFloat width_crop = (usableArea.width * (1.0 - (CORNER_MARKER_DEFAULT_WIDTH_PERC * 2 / 100)));
    CGFloat height_crop = usableArea.height *  (1.0 - (CORNER_MARKER_DEFAULT_WIDTH_PERC * 2 / 100 ));
	
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(radians(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(radians(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(radians(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectApplyAffineTransform(CGRectMake(x_crop, y_crop, width_crop, height_crop), rectTransform));
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    UIImage *newCroppedImage = [croppedImage rotate:UIImageOrientationRight] ;
    
    //Saving it CameraRoll
    [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
    
    return newCroppedImage;
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
                
                
                //Crop image within corner bounds
                image = [self cropImageWithinBounds:image];
                
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

#pragma mark - Action methods

-(void) btnCloseHandler{
    if(self.delegate){
        [self.delegate closeButtonHasBeenTouched];
    }
}

@end
