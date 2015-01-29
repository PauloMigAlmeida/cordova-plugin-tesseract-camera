//
//  LDCTesseractImageRecognizer.m
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/23/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
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
