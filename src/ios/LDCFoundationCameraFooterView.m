//
//  LDCFoundationCameraFooterView.m
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/28/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import "LDCFoundationCameraFooterView.h"

@implementation LDCFoundationCameraFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
    }
    return self;
}

-(void) initialize{
    self.backgroundColor = [UIColor blackColor];
    
    CGSize stillImageCaptureButtonSize = CGSizeMake(110, 106);
    CGRect stillImageCaptureButtonRect = CGRectMake(
                                                (self.frame.size.width  - stillImageCaptureButtonSize.width ) / 2,
                                                self.frame.size.height - stillImageCaptureButtonSize.height,
                                                stillImageCaptureButtonSize.width,
                                                stillImageCaptureButtonSize.height);
    
    UIButton *stillImageCaptureButton = [[UIButton alloc] initWithFrame:stillImageCaptureButtonRect];
    [stillImageCaptureButton setImage:[UIImage imageNamed:@"btnFotografarNotinha.png"] forState:UIControlStateNormal];
    
    [self addSubview:stillImageCaptureButton];
}

@end
