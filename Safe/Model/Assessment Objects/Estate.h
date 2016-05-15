//
//  Estate.h
//  Milk
//
//  Created by Lucian Todorovici on 27/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Room.h"

@interface Estate : NSObject

@property(strong,nonatomic) CLPlacemark *placemark;
@property(strong,atomic) NSNumber *surface;
@property(strong,nonatomic) NSDate *builtDate;
@property(strong,nonatomic) NSArray<Room *> *rooms;

@end
