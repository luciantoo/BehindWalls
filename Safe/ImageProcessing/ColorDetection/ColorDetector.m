//
//  ColorDetector.m
//  Behind Walls
//
//  Created by Lucian Todorovici on 15/06/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "ColorDetector.h"
#import "Constants.h"

@implementation ColorDetector

-(UIImage*)extractColorImageFromImage:(UIImage*)targetImage TargetRect:(CGRect)targetRect
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [[CIImage alloc] initWithCGImage:targetImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:kExtractColourFilter];
    CIVector *vector = [CIVector vectorWithCGRect:targetRect];
    
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:vector forKey:kCIInputExtentKey];
    
    CIImage *resultImage = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:resultImage fromRect:resultImage.extent];
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
    const UInt8 *pixelDataPointer = CFDataGetBytePtr(pixelData);
    const CGFloat colorDivider = 255.0f;
    NSLog(@"Color space: %@",CGImageGetColorSpace(targetImage.CGImage));
    //the image has only one pixel
    CGFloat red = pixelDataPointer[0]/colorDivider; // RED
    CGFloat green = pixelDataPointer[1]/colorDivider; // GREEN
    CGFloat blue = pixelDataPointer[2]/colorDivider; // BLUE
    
    NSLog(@"Color: %i,%i,%i",pixelDataPointer[0],pixelDataPointer[1],pixelDataPointer[2]);
//    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return [UIImage imageWithCIImage:resultImage];
}

@end
