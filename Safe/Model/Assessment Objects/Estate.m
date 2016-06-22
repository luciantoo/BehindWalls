//
//  Estate.m
//  Milk
//
//  Created by Lucian Todorovici on 27/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "Estate.h"

@implementation Estate
@synthesize placemark;

- (id)init
{
    if(self = [super init]) {
        
        return self;
    }
    NSAssert(self,@"Cannot create new estate object");
    return nil;
}

@end
