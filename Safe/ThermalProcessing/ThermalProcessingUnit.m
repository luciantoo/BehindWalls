//
//  ThermalProcessingUnit.m
//  Safe
//
//  Created by Lucian Todorovici on 14/01/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "ThermalProcessingUnit.h"

#define RECT_LEN 30

@implementation ThermalProcessingUnit

-(instancetype)initWithTargetTemperature:(double)targetTemp {
    if(self = [super init]){
        _targetTemperature = targetTemp+273.15;
    }
    return self;
}

-(BOOL)isTargetTemperatureReached:(NSData *)radiometricData size:(CGSize)size updateView:(UILabel *)label {
    double minTemp = _targetTemperature - 2, maxTemp = _targetTemperature + 2;
    long j;
    uint16_t *buffer = (uint16_t*) [radiometricData bytes];
    int countArray[RECT_LEN*2],k=0;
    for(j = size.height/2 - RECT_LEN ; j< size.height/2 + RECT_LEN; j++){
        int belowCount = 0;
//        NSRange range = NSMakeRange(480*j, 60);
//        [radiometricData getBytes:&buffer range:range];
        for(int i = 0; i<RECT_LEN*2 ; i++){
//            if(buffer[j*(int)size.width+i]/100<maxTemp && buffer[j*(int)size.width+i]/100>minTemp){
            if(((buffer[j*(int)size.width+i])/100)>_targetTemperature){
                belowCount++;
            }
        }
        countArray[k] = belowCount;
        k++;
    }
    int cntPositive = 0;
    for(int i = 0; i<k ; i++){
        if(countArray[i]>40){
            cntPositive++;
        }
    }
    
    int middle = (int)size.width*((int)size.height/2) + (int)size.width/2;
    int last = size.width*size.height-1;
    float temp = ((float)buffer[middle]/100.0f) - 273.15;
    if(label){
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = [NSString stringWithFormat:@"%.02f °C",temp];
        });
    }
    
    if(cntPositive>30){
        return YES;
    }
    return NO;
}

@end
