//
//  Altimeter.m
//  Behind Walls
//
//  Created by Lucian Todorovici on 16/06/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "AltimeterWrapper.h"

@interface AltimeterWrapper()
@property(strong,nonatomic) CMAltimeter *altimeter;
@property(strong,nonatomic) NSOperationQueue *altimeterDeliveryQueue;
@end

@implementation AltimeterWrapper

#pragma mark - Constructor -

-(id)init
{
    if (self=[super init]) {
        _altimeter = [CMAltimeter new];
        _altimeterDeliveryQueue = [NSOperationQueue new];
        return self;
    }
    NSAssert(self, @"Could not instantiate AltimeterWrapper");
    return nil;
}

#pragma mark - Functionality -

- (void)showAltitudeInLabel:(UILabel*)label
{
    if([CMAltimeter isRelativeAltitudeAvailable]){
        [_altimeter startRelativeAltitudeUpdatesToQueue:_altimeterDeliveryQueue withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
            //check the queue of the handler
            //UI operations must be performed only on the main queue
            if (altitudeData && !error) {
                NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
                [mainQueue addOperationWithBlock:^{
                    NSString *altimeterString = [NSString stringWithFormat:@"%.2f m",altitudeData.relativeAltitude.floatValue];
                    label.text = altimeterString;
                }];
            }
        }];
    }else { // altimeter data is not available , display this fact to the user
        label.text = @"n/a";
    }
}

@end
