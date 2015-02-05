//
//  LDCTakePicturePlugin.h 
//  InstaGraacCamera2
//
//  Created by Paulo Miguel Almeida on 1/27/15.
//  Copyright (c) 2015 Loducca Publicidade. All rights reserved.
//

#import <UIKit/UIKit.h>

//Libraries
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

//Custom components
#import "LDCTakePictureViewController.h"


@interface LDCTakePicturePlugin : CDVPlugin<LDCTakePictureViewControllerDelegate>


-(void)takePicture:(CDVInvokedUrlCommand *) command;

@end
