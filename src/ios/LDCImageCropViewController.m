//
//  LDCImageCropViewController.m
//
//  Version 0.0.1
//
//  The MIT License (MIT)
//
//  Original work Copyright (c) 2014 Ming Yang <myang.git @t gmail.com>
//  Modified work Copyright (c) 2015 Paulo Miguel Almeida Rodenas <paulo.ubuntu@gmail.com>
//
//  Get the latest version from here:
//
//  https://github.com/myang-git/iOS-Image-Crop-View
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

#import "LDCImageCropViewController.h"

#pragma mark LDCImageCropViewController implementation

#define FOOTER_DEFAULT_HEIGHT 132

@implementation LDCImageCropViewController

@synthesize cropView;
@synthesize cropFooterView;

-(id)initWithImage:(UIImage*) image{
    self =  [super init];
    if (self){
        self.image = image;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(BOOL)shouldAutorotate{
    return false;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self){
        UIView *contentView = [[UIView alloc] init];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentView.backgroundColor = [UIColor blackColor];
        
        CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
        CGRect cropViewRect = CGRectMake(0, statusBarSize.height, self.view.bounds.size.width, self.view.bounds.size.height - FOOTER_DEFAULT_HEIGHT - statusBarSize.height);
        CGRect cropFooterRect = CGRectMake(0, cropViewRect.size.height, self.view.bounds.size.width, FOOTER_DEFAULT_HEIGHT);
        
        self.cropView  = [[LDCImageCropImageCropView alloc] initWithFrame:cropViewRect blurOn:self.blurredBackground];
        self.cropFooterView  = [[LDCImageCropFooterView alloc] initWithFrame:cropFooterRect];
        self.cropFooterView.delegate = self;
        
        self.view = contentView;
        [contentView addSubview:cropView];
        [contentView addSubview:cropFooterView];
        [cropView setImage:self.image];
    }
}


#pragma mark - LDCImageCropFooterViewDelegate methods

-(void)touchedCropButton{
    if([self.delegate respondsToSelector:@selector(didFinishCropping:)]){
        UIImage *cropped;
        if (self.image != nil){
            CGRect CropRect = self.cropView.cropAreaInImage;
            CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], CropRect) ;
            cropped = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
        }
        
        //Saving it CameraRoll
        [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[cropped CGImage] orientation:(ALAssetOrientation)[cropped imageOrientation] completionBlock:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate didFinishCropping:cropped];
        }];
    }
}

-(void)touchedCancelButton{
    if([self.delegate respondsToSelector:@selector(didCancel)]){
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate didCancel];
        }];
    }
}

@end


