//
//  ThermalProcessingUnit.h
//  Safe
//
//  Created by Lucian Todorovici on 14/01/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FLIROneSDK/FLIROneSDK.h>

@interface ThermalProcessingUnit : NSObject

@property(readonly,assign) double targetTemperature;

-(instancetype)initWithTargetTemperature:(double)targetTemp;

-(BOOL)isTargetTemperatureReached:(NSData *)radiometricData size:(CGSize)size updateView:(UILabel *)label;

@end
