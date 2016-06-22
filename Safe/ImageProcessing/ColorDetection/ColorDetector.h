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

-(UIImage*)extractColorImageFromImage:(UIImage*)targetImage TargetRect:(CGRect)targetRect;

@end
