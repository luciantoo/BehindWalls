//
//  SobelFilter.h
//  Milk
//
//  Created by TOO on 13/03/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SobelFilter : NSObject

- (UIImage *)toGrayscale:(UIImage *)img;
-(UIImage*)filteredImageFromImage:(UIImage*)srcImage;

@end
