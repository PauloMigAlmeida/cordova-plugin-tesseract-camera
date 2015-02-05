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

@implementation LDCImageCropViewController

@synthesize delegate;
@synthesize cropView;

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self){
        UIView *contentView = [[UIView alloc] init];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentView.backgroundColor = [UIColor whiteColor];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector(cancel:)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
        CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
        CGRect view = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - [[self navigationController] navigationBar].bounds.size.height - statusBarSize.height);
        self.cropView  = [[LDCImageCropImageCropView alloc] initWithFrame:view blurOn:self.blurredBackground];
        self.view = contentView;
        [contentView addSubview:cropView];
        [cropView setImage:self.image];
    }
}

- (IBAction)cancel:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(ImageCropViewControllerDidCancel:)])
    {
        [self.delegate ImageCropViewControllerDidCancel:self];
    }
    
}

- (IBAction)done:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(ImageCropViewController:didFinishCroppingImage:)])
    {
        UIImage *cropped;
        if (self.image != nil){
            CGRect CropRect = self.cropView.cropAreaInImage;
            CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], CropRect) ;
            cropped = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
        }
        [self.delegate ImageCropViewController:self didFinishCroppingImage:cropped];
    }
    
}
@end


