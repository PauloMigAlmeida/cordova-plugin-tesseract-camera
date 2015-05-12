//
//  LDCFoundationCameraFooterView.m
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
	
	CGSize snapStillImageCaptureButtonSize = CGSizeMake(90, 86);
	CGRect snapStillImageCaptureButtonRect = CGRectMake(
														(self.frame.size.width  - snapStillImageCaptureButtonSize.width ) / 2,
														self.frame.size.height - snapStillImageCaptureButtonSize.height -7,
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
