//
//  Altimeter.h
//  Behind Walls
//
//  Created by Lucian Todorovici on 16/06/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import CoreMotion;

@interface AltimeterWrapper : NSObject

/**
 *  Displays the relative displacement of the device on the vertical axis
 *  in the label received as parameter
 *
 *  @param label UILabel in which the result is displayed
 */
- (void)showAltitudeInLabel:(UILabel*)label;

@end
