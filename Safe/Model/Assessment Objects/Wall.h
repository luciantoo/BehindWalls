//
//  Wall.h
//  Milk
//
//  Created by Lucian Todorovici on 27/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CoreMaterial{
    Wood, Brick, Cardboard
};

@interface Wall : NSObject

@property(assign,atomic)enum CoreMaterial coreMaterial;
@property(assign,atomic) BOOL hasDoor;
@property(assign,atomic) BOOL hasWindow;

@end
