//
//  MapDisplayableProtocol.h
//  Behind Walls
//
//  Created by Lucian Todorovici on 17/06/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MapDisplayableProtocol <NSObject>
@property(strong,nonatomic) CLPlacemark* placemark;


@end
