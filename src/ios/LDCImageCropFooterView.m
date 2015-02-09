//
//  LDCImageCropFooterView.m
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

#import "LDCImageCropFooterView.h"

@implementation LDCImageCropFooterView

#define DEFAULT_BUTTON_SIZE CGSizeMake(100, 50)


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
    }
    return self;
}

-(void) initialize{
    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(
                                   10,
                                   (self.frame.size.height - DEFAULT_BUTTON_SIZE.height) / 2
                                   , DEFAULT_BUTTON_SIZE.width
                                   , DEFAULT_BUTTON_SIZE.height
    );
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(touchUpCloseButton) forControlEvents:UIControlEventTouchUpInside];

    
    
    UIButton* cropButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cropButton.frame = CGRectMake(
                                   self.frame.size.width - 10 - DEFAULT_BUTTON_SIZE.width,
                                   (self.frame.size.height - DEFAULT_BUTTON_SIZE.height) / 2
                                   , DEFAULT_BUTTON_SIZE.width
                                   , DEFAULT_BUTTON_SIZE.height
                                   );
    [cropButton setTitle:@"Crop" forState:UIControlStateNormal];
    [cropButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [cropButton setTitleColor:[UIColor colorWithRed:0.88 green:0.90 blue:0.21 alpha:1.0] forState:UIControlStateNormal];
    [cropButton addTarget:self action:@selector(touchUpCropButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:closeButton];
    [self addSubview:cropButton];
}

#pragma mark - Action methods

-(void) touchUpCloseButton
{
    if([self.delegate respondsToSelector:@selector(touchedCancelButton)]){
        [self.delegate touchedCancelButton];
    }
}

-(void) touchUpCropButton
{
    if([self.delegate respondsToSelector:@selector(touchedCropButton)]){
        [self.delegate touchedCropButton];
    }
}

@end
