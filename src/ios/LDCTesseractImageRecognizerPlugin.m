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
    NSString* imageData = (NSString*)[command.arguments objectAtIndex:0];
    NSString* charWhiteList = (NSString*)[command.arguments objectAtIndex:1 withDefault:nil];
    
    [self.commandDelegate runInBackground:^{
        
        LDCTesseractImageRecognizer* tesseract = [[LDCTesseractImageRecognizer alloc] init];
        
        UIImage* imageToBeRecognized = [self imageFromBase64String:imageData];
        
        [tesseract recognizeText:imageToBeRecognized AndCharWhitelist:charWhiteList];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}

-(UIImage*) imageFromBase64String:(NSString*) base64String{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    return [UIImage imageWithData:decodedData];
}
@end
