//
//  Constants.h
//  Milk
//
//  Created by Lucian Todorovici on 27/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark - Model -
#define kNorthWallSegue @"NorthWallSegue"
#define kEastWallSegue @"EastWallSegue"
#define kSouthWallSegue @"SouthWallSegue"
#define kWestWallSegue @"WestWallSegue"

#define kNorthWallTitle @"North Wall Details"
#define kEastWallTitle @"East Wall Details"
#define kWestWallTitle @"West Wall Details"
#define kSouthWallTitle @"South Wall Details"


#pragma mark - Weather Service -
#define kOpenweathermapAPIKey @"APPID=d9bbb6bc79e5dd3ec775c1e4b9c9b8bc"
#define kOpenweathermapURL @"http://api.openweathermap.org/data/2.5/weather?"


#pragma mark - Core Image Filters -
#define kExtractColourFilter @"CIAreaAverage"


#pragma mark - Error domains -
#define WeatherErrorDomain @"weather_error"

#pragma mark - Error codes -
#define MalformedJSONErrorCode 1

#pragma mark - Error descriptions -
#define MalformedJSONErrorDescription @"The JSON does not contain the \"main\" and the \"temp\" keys"

#endif /* Constants_h */
