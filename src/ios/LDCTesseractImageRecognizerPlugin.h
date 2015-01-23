//
//  LDCTesseractImageRecognizerPlugin.h
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/23/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import <Foundation/Foundation.h>

//Libraries
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

//Local Files
#import "LDCTesseractImageRecognizer.h"

@interface LDCTesseractImageRecognizerPlugin : CDVPlugin

-(void) recognizeImage:(CDVInvokedUrlCommand*) command;

@end
