//
//  LDCImageCropViewController.h
//
//  Version 0.0.1
//
//  The MIT License (MIT)
//
//  Original work Copyright (c) 2014 Ming Yang <myang.git @t gmail.com>
//  Modified work Copyright (c) 2014 Paulo Miguel Almeida Rodenas <paulo.ubuntu@gmail.com>
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

#import <UIKit/UIKit.h>

//Libraries - Temporary
#import <AssetsLibrary/AssetsLibrary.h>

//Custom components
#import "LDCImageCropImageCropView.h"
#import "LDCImageCropFooterView.h"

//CGRect SquareCGRectAtCenter(CGFloat centerX, CGFloat centerY, CGFloat size);

//UIView* dragView;

@protocol LDCImageCropViewControllerDelegate <NSObject>

-(void)didFinishCropping:(UIImage*) croppedImage;
-(void)didCancel;

@end

@interface LDCImageCropViewController : UIViewController<LDCImageCropFooterViewDelegate> {
    LDCImageCropImageCropView * cropView;
}
@property (nonatomic) BOOL blurredBackground;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) LDCImageCropImageCropView* cropView;
@property (nonatomic, retain) LDCImageCropFooterView* cropFooterView;
@property (nonatomic, retain) id<LDCImageCropViewControllerDelegate> delegate;

- (id)initWithImage:(UIImage*)image;

@end
