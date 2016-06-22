//
//  WeatherManager.h
//  Milk
//
//  Created by Lucian Todorovici on 27/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@import CoreLocation;
@import UIKit;

@interface WeatherManager : NSObject

+ (WeatherManager*)sharedInstance;

/**
 *  Performs a http request to the openweathermap.org weather service server. 
 *  When the response arrives, the temperature for the requested location is extracted 
 *  and displayed in a label
 *
 *  @param coordinates Geographical coordinates corresponding to the target place
 *  @param label       A UILabel in which the result is displayed
 */
- (void)requestTemperatureForCoordinates:(CLLocationCoordinate2D)coordinates inLabel:(UILabel*)label;


@end
