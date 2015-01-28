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
    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    
    CGSize snapStillImageCaptureButtonSize = CGSizeMake(110, 106);
    CGRect snapStillImageCaptureButtonRect = CGRectMake(
                                                (self.frame.size.width  - snapStillImageCaptureButtonSize.width ) / 2,
                                                self.frame.size.height - snapStillImageCaptureButtonSize.height,
                                                snapStillImageCaptureButtonSize.width,
                                                snapStillImageCaptureButtonSize.height);
    
    UIButton *snapStillImageCaptureButton = [[UIButton alloc] initWithFrame:snapStillImageCaptureButtonRect];
    [snapStillImageCaptureButton setImage:[UIImage imageNamed:@"btnFotografarNotinha.png"] forState:UIControlStateNormal];

    [snapStillImageCaptureButton addTarget:self action:@selector(snapStillImageCameraHandler) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:snapStillImageCaptureButton];
}

-(void) snapStillImageCameraHandler{
    if(self.delegate){
        [self.delegate snapStillImageCaptureButtonTouched];
    }
}

@end
