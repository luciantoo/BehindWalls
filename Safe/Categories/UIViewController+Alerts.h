//
//  UIViewController+Alerts.h
//  BehindWalls
//
//  Created by TOO on 23/06/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alerts)

- (void)presentInfoAlertWithTitle:(NSString *)title message:(NSString *)text;
- (void)presentActionAlertWithTitle:(NSString *)title message:(NSString *)text
                             action:(void (^)(UIAlertAction *action))handler;

@end
