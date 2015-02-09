//
//  LDCTesseractImageRecognizer.m
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

#import "LDCTesseractImageRecognizer.h"

@interface LDCTesseractImageRecognizer()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation LDCTesseractImageRecognizer


-(instancetype)init{
    self = [super init];
    if(self){
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void)recognizeText:(UIImage *)image  AndCompletion:(G8RecognitionOperationCallback) completion
{
    [self recognizeText:image AndCharWhitelist:nil AndCompletion:completion];
}

-(void)recognizeText:(UIImage *)image AndCharWhitelist:(NSString *)charWhitelist AndCompletion:(G8RecognitionOperationCallback) completion
{
    
    UIImage *bwImage = image;
    
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] init];
    
    operation.tesseract.language = @"eng";
    
    operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
    
    if(charWhitelist){
        operation.tesseract.charWhitelist = charWhitelist;
    }
    
    operation.tesseract.image = bwImage;
    
    // Optionally limit the region in the image on which Tesseract should
    // perform recognition to a rectangle
    //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
    
    operation.recognitionCompleteBlock = completion;
    
    // Finally, add the recognition operation to the queue
    [self.operationQueue addOperation:operation];
}

@end
