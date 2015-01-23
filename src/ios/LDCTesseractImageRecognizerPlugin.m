//
//  LDCTesseractImageRecognizerPlugin.m
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/23/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import "LDCTesseractImageRecognizerPlugin.h"

@implementation LDCTesseractImageRecognizerPlugin

-(void)recognizeImage:(CDVInvokedUrlCommand *)command
{
    NSString* imagePath = (NSString*)[command.arguments objectAtIndex:0];
    
    LDCTesseractImageRecognizer* tesseract = [[LDCTesseractImageRecognizer alloc] init];
    [tesseract recognizeText:[UIImage imageNamed:imagePath] AndMaskInput:@"0123456789"];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}
@end
