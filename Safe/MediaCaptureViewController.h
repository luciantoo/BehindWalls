//
//  MediaCaptureViewController.h
//  Milk
//
//  Created by TOO on 21/02/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLIROneSDK/FLIROneSDK.h>
#import <Photos/Photos.h>

@import CoreLocation;

@interface MediaCaptureViewController : UIViewController <FLIROneSDKStreamManagerDelegate,FLIROneSDKImageReceiverDelegate,CLLocationManagerDelegate>

@end
