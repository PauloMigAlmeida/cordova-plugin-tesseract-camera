//
//  LDCOpenCVIntegration.h
//  InstaGraacc
//
//  Created by Paulo Miguel Almeida on 2/13/15.
//
//

#import <Foundation/Foundation.h>

//Libraries
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

//Temp Imports
#import <AssetsLibrary/AssetsLibrary.h>

@interface LDCOpenCVIntegration : NSObject

-(double) calculateSkewAngle:(UIImage*) image;
-(UIImage*) resize:(UIImage*) image AndFactorX:(double) factorX AndFactorY:(double) factorY;

@end
