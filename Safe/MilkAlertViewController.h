//
//  MilkAlertViewController.h
//  Safe
//
//  Created by Lucian Todorovici on 14/01/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLIROneSDK/FLIROneSDK.h>

@interface MilkAlertViewController : UIViewController<FLIROneSDKStreamManagerDelegate,FLIROneSDKImageReceiverDelegate>

@end
