//
//  LDCFoundationCameraFooterView.h
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/28/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDCFoundationCameraFooterViewDelegate <NSObject>

-(void) snapStillImageCaptureButtonTouched;

@end

@interface LDCFoundationCameraFooterView : UIView

@property (nonatomic, retain) id<LDCFoundationCameraFooterViewDelegate> delegate;

@end
