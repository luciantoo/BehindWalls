//
//  ColorDetector.h
//  Behind Walls
//
//  Created by Lucian Todorovici on 15/06/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface ColorDetector : NSObject

/**
 *  This method uses a Core Image filter to detect the color from an image
 *
 *  @param targetImage The image in which the color will be detected
 *  @param targetRect  A CGRect to restrict the area of the detection
 *
 *  @return A one pixel image containing the color detected in the target image
 */
- (UIImage*)extractColorImageFromImage:(UIImage*)targetImage targetRect:(CGRect)targetRect;


/**
 *  Detects the color from an image using a Core Image filter
 *
 *  @param targetImage The image in which the color will be detected
 *  @param targetRect  A CGRect to restrict the area of the detection
 *
 *  @return The corresponding UIColor detected in the image
 */
- (UIColor*)extractColorFromImage:(UIImage*)targetImage targetRect:(CGRect)targetRect;

@end
