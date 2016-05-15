//
//  Room.h
//  Milk
//
//  Created by Lucian Todorovici on 27/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wall.h"

@interface Room : NSObject

@property(strong,atomic) NSArray<Wall *> *walls;
@property(strong,atomic) NSNumber *surface;

@end
