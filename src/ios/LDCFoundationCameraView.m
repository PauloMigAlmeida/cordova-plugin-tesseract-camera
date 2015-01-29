//
//  LDCFoundationCameraView.m
//  InstaGraacCamera
//
//  Created by Paulo Miguel Almeida on 1/21/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import "LDCFoundationCameraView.h"

@interface LDCFoundationCameraView()

// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) id runtimeErrorHandlingObserver;

//UI compoenents
@property(nonatomic, retain) LDCFoundationCameraFooterView* footerView;
@property(nonatomic, retain) UIImageView* cornerUpperLeft;
@property(nonatomic, retain) UIImageView* cornerUpperRight;
@property(nonatomic, retain) UIImageView* cornerBottomLeft;
@property(nonatomic, retain) UIImageView* cornerBottomRight;

@end

#define FOOTER_DEFAULT_HEIGHT 132
#define CORNER_MARKER_PADDING_START_PERC 5.0
#define CORNER_MARKER_DEFAULT_HEIGHT_PERC 8.0
#define CORNER_MARKER_DEFAULT_WIDTH_PERC 8.0

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

#pragma mark - Action methods

-(void) initializeCamera
{
    // Create the AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    
    // Setup the preview view
    [self setSession:session];
    
    // Check for device authorization
    [self checkDeviceAuthorizationStatus];
    
    [self setPresetResolution];
    
    // Dispatch the rest of session setup to the sessionQueue so that the main queue isn't blocked.
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(sessionQueue, ^{
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [LDCFoundationCameraView deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:videoDeviceInput])
        {
            [session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
        }
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ([session canAddOutput:stillImageOutput])
        {
            [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
            [session addOutput:stillImageOutput];
            [self setStillImageOutput:stillImageOutput];
        }
        
    });
    
    dispatch_async([self sessionQueue], ^{
        [[self session] startRunning];
    });
    
    //Add LDCFoundationCameraFooterView
    CGRect cameraFooterRect = CGRectMake(
                                         self.frame.origin.x,
                                         self.frame.size.height - FOOTER_DEFAULT_HEIGHT,
                                         self.frame.size.width,
                                         FOOTER_DEFAULT_HEIGHT
                                         );
    self.footerView = [[LDCFoundationCameraFooterView alloc] initWithFrame:cameraFooterRect];
    self.footerView.delegate = self;
    [self addSubview:self.footerView];
    
    
    //Adding Corner Markers
    CGRect usableArea = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - FOOTER_DEFAULT_HEIGHT);
    CGSize defaultCornerSize = CGSizeMake(64, 55);
    
    self.cornerUpperLeft = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                 (usableArea.size.width * (CORNER_MARKER_DEFAULT_WIDTH_PERC / 100)),
                                                                                 (usableArea.size.height * (CORNER_MARKER_DEFAULT_HEIGHT_PERC / 100)) + (usableArea.size.height * (CORNER_MARKER_PADDING_START_PERC / 100)),
                                                                                 defaultCornerSize.width,
                                                                                 defaultCornerSize.height
                                                                                 )];
    self.cornerUpperLeft.image = [UIImage imageNamed:@"corner_upper_left.png"];
    self.cornerUpperLeft.backgroundColor = [UIColor clearColor];
    
    self.cornerUpperRight = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                  (usableArea.size.width * (1 - (CORNER_MARKER_DEFAULT_WIDTH_PERC / 100))) - defaultCornerSize.width,
                                                                                  (usableArea.size.height * (CORNER_MARKER_DEFAULT_HEIGHT_PERC / 100)) + (usableArea.size.height * (CORNER_MARKER_PADDING_START_PERC / 100)),
                                                                                  defaultCornerSize.width,
                                                                                  defaultCornerSize.height
                                                                                  )];
    self.cornerUpperRight.image = [UIImage imageNamed:@"corner_upper_right.png"];
    self.cornerUpperRight.backgroundColor = [UIColor clearColor];
    
    self.cornerBottomLeft = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                  (usableArea.size.width * (CORNER_MARKER_DEFAULT_WIDTH_PERC / 100)),
                                                                                  (usableArea.size.height * (1 - (CORNER_MARKER_DEFAULT_HEIGHT_PERC / 100))) - defaultCornerSize.height,
                                                                                  defaultCornerSize.width,
                                                                                  defaultCornerSize.height
                                                                                  )];
    self.cornerBottomLeft.image = [UIImage imageNamed:@"corner_bottom_left.png"];
    self.cornerBottomLeft.backgroundColor = [UIColor clearColor];
    
    self.cornerBottomRight = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                   (usableArea.size.width * (1 - (CORNER_MARKER_DEFAULT_WIDTH_PERC / 100))) - defaultCornerSize.width,
                                                                                   (usableArea.size.height * (1 - (CORNER_MARKER_DEFAULT_HEIGHT_PERC / 100))) - defaultCornerSize.height,
                                                                                   defaultCornerSize.width,
                                                                                   defaultCornerSize.height
                                                                                   )];
    self.cornerBottomRight.image = [UIImage imageNamed:@"corner_bottom_right.png"];
    self.cornerBottomRight.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.cornerUpperLeft];
    [self addSubview:self.cornerUpperRight];
    [self addSubview:self.cornerBottomLeft];
    [self addSubview:self.cornerBottomRight];
}

-(UIImage*) cropImageWithinBounds:(UIImage*) image{
    CGFloat factor = self.frame.size.width / image.size.width;
    
    NSLog(@"%s self.cornerUpperLeft: %@",__PRETTY_FUNCTION__, NSStringFromCGRect(self.cornerUpperLeft.frame));
    CGFloat x_crop = self.cornerUpperLeft.frame.origin.x / factor ;
    CGFloat y_crop = self.cornerUpperLeft.frame.origin.y  / factor;
    CGFloat width_crop = (self.cornerUpperRight.frame.origin.x + self.cornerUpperRight.frame.size.width)  / factor;
    CGFloat height_crop = (self.cornerBottomLeft.frame.origin.y + self.cornerBottomLeft.frame.size.height)  / factor;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(x_crop, y_crop, width_crop, height_crop));
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);

    croppedImage = [self rotateImageUp:croppedImage];
    NSLog(@"croppedImage %d", croppedImage.imageOrientation == UIImageOrientationUp);
    
    //Saving it CameraRoll
    [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[croppedImage CGImage] orientation:(ALAssetOrientation)[croppedImage imageOrientation] completionBlock:nil];
    
    return [croppedImage g8_grayScale];
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

- (UIImage *)rotateImageUp:(UIImage*)src
{
    /**
        Method taken from SO 1315251 and 5983090. Thanks guys
     */
    double radian = 0;
    
    if (src.imageOrientation == UIImageOrientationRight) {
        radian = radians(90);
    } else if (src.imageOrientation == UIImageOrientationLeft) {
        radian = radians(-90);
    }
    
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0, src.size.width, src.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radian);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radian);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), [src CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - AVFoundation methods
- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted)
        {
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        }
        else
        {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"AVCam!"
                                            message:@"AVCam doesn't have permission to use Camera, please change privacy settings"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}

- (BOOL)isSessionRunningAndDeviceAuthorized
{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized
{
    return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}


-(void) setPresetResolution
{
    if([self.session canSetSessionPreset:AVCaptureSessionPresetiFrame1280x720])
    {
        self.session.sessionPreset = AVCaptureSessionPresetiFrame1280x720;
    }
    else
    {
        NSLog(@"It was not possible to set preset, using default value instead");
    }
}


-(void) snapStillImage{
    dispatch_async([self sessionQueue], ^{
        // Update the orientation on the still image output video connection before capturing.
        [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[self layer] connection] videoOrientation]];
        
        // Flash set to Auto for Still Capture
        [self setFlashMode:AVCaptureFlashModeAuto forDevice:[[self videoDeviceInput] device]];
        
        // Capture a still image.
        [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            if (imageDataSampleBuffer)
            {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                
                //Saving it CameraRoll
//                [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
            
                
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


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error)
        NSLog(@"%@", error);
    
    // Note the backgroundRecordingID for use in the ALAssetsLibrary completion handler to end the background task associated with this recording. This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's -isRecording is back to NO — which happens sometime after this method returns.
    UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingID];
    [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
    
    [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error)
            NSLog(@"%@", error);
        
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
        
        if (backgroundRecordingID != UIBackgroundTaskInvalid)
            [[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
    }];
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:flashMode])
    {
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

#pragma mark - LDCFoundationCameraFooterViewDelegate methods

-(void)snapStillImageCaptureButtonTouched{
    [self snapStillImage];
}


@end
