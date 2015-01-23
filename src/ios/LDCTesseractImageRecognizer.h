//
//  LDCTesseractImageRecognizer.h
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/23/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TesseractOCR/TesseractOCR.h>
#import <TesseractOCR/G8RecognitionOperation.h>


@interface LDCTesseractImageRecognizer : NSObject

-(void) recognizeText:(UIImage*) image AndMaskInput:(NSString*) maskInput;

@end
