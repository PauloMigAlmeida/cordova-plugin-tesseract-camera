//
//  LDCTesseractCameraRectDetectionViewController.h
//  InstaGraacc
//
//  Created by Paulo Miguel Almeida on 2/12/15.
//
//

//Libraries
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <GLKit/GLKit.h>

typedef NS_ENUM(NSInteger,IPDFCameraViewType)
{
    IPDFCameraViewTypeBlackAndWhite,
    IPDFCameraViewTypeNormal
};

@interface LDCTesseractCameraRectDetectionViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>

@end
