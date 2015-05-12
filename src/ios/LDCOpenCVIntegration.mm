//
//  LDCOpenCVIntegration.m
//  InstaGraacc
//
//  Created by Paulo Miguel Almeida on 2/13/15.
//
//

#import "LDCOpenCVIntegration.h"

using namespace cv;
using namespace std;

@implementation LDCOpenCVIntegration


- (Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

-(double) calculateSkewAngle:(UIImage*) image{
    Mat inputMat = [self cvMatFromUIImage:image];
    //Convert to gray scale
    Mat src;
    cv::Size size;
    cvtColor(inputMat, src, COLOR_BGR2GRAY);
    size = src.size();
    
   
    //Adaptative Thresholding
    Mat adaptative_threshold(src.rows,src.cols, CV_8UC1);
    threshold(src, adaptative_threshold, 0, 255, THRESH_OTSU);
    src = adaptative_threshold;
    adaptative_threshold.release();
    [self saveInCameraRoll:src];
////    //Applying Ellipse Kernel
//    
//    int erosion_type = cv::MORPH_RECT;
//    int erosion_size = 3;
//    cv::Mat element = cv::getStructuringElement(erosion_type,
//                                                cv::Size(2 * erosion_size + 1, 2 * erosion_size + 1),
//                                                cv::Point(erosion_size, erosion_size));
//    cv::erode(src, src, element);
//    cv::erode(src, src, element);
//    cv::erode(src, src, element);
//    [self saveInCameraRoll:src];
    
    
    //Invert colors
    bitwise_not(src, src);
    [self saveInCameraRoll:src];
    
    //Scale down image. It's well known that houghLinesP doesn't perform well on big images. =/
    Mat scale_down;
    resize(src, scale_down, cv::Size(), 0.25, 0.25);
    src = scale_down;
    scale_down.release();
    
    Mat scale_down_input;
    resize(inputMat, scale_down_input, cv::Size(), 0.25, 0.25);
    inputMat = scale_down_input;
    scale_down_input.release();
    
    //HoughP
    vector<cv::Vec4i> lines;
    cv::HoughLinesP(src, lines, 1, CV_PI/180, 100, src.size().width / 2.f, 20);
    //Mean of the line angles
    double angle = 0.;
    unsigned long nb_lines = lines.size();
    NSLog(@"%s nb_lines: %lu",__PRETTY_FUNCTION__,nb_lines);
    for (unsigned i = 0; i < nb_lines; ++i)
    {
        line(inputMat,
                cv::Point(lines[i][0], lines[i][1]),
                cv::Point(lines[i][2], lines[i][3]),
                cv::Scalar(255, 0 ,0));
        
        angle += atan2((double)lines[i][3] - lines[i][1],
                       (double)lines[i][2] - lines[i][0]);
    }
    [self saveInCameraRoll:inputMat];
    angle /= nb_lines; // mean angle, in radians.
    return  angle * 180 / CV_PI ;
}

-(void) saveInCameraRoll:(Mat) src
{
    UIImage* temp;
    temp = [self UIImageFromCVMat:src];
    [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[temp CGImage] orientation:(ALAssetOrientation)[temp imageOrientation] completionBlock:nil];
}

-(UIImage*) resize:(UIImage*) image AndFactorX:(double) factorX AndFactorY:(double) factorY
{
    Mat src = [self cvMatFromUIImage:image];
    Mat scale_down;
    resize(src, scale_down, cv::Size(), factorX, factorY);
    src.release();
    return [self UIImageFromCVMat:scale_down];
}

-(UIImage*) resize:(UIImage*) image AndTargetWidth:(double) targetWidth
{
    Mat src = [self cvMatFromUIImage:image];
    Mat scale_down;
    
    float oldWidth = src.size().width;
    float scaleFactor = targetWidth / oldWidth;
    float newHeight = src.size().height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    cv::Size size(newWidth,newHeight);
    
    resize(src, scale_down, size);
    src.release();
    return [self UIImageFromCVMat:scale_down];
}

@end
