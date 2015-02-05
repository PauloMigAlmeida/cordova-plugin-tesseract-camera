//
//  LDCTakePictureViewController.h
//  InstaGraacc
//
//  Created by Paulo Miguel Almeida on 2/5/15.
//
//

#import <UIKit/UIKit.h>

//Libraries
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

//Custom Components
#import "LDCFoundationCameraView.h"
#import "LDCFoundationCameraFooterView.h"

//Categories
#import <TesseractOCR/UIImage+G8Filters.h>
#import "UIImage+Rotate.h"

@protocol LDCTakePictureViewControllerDelegate <NSObject>

-(void) snapStillImageHasBeenTaken:(UIImage*) image;
-(void) closeButtonHasBeenTouched;
@end

@interface LDCTakePictureViewController : UIViewController<LDCFoundationCameraFooterViewDelegate>

@property(nonatomic, retain) id<LDCTakePictureViewControllerDelegate> delegate;

@end
