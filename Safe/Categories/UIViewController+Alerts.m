//
//  UIViewController+Alerts.m
//  BehindWalls
//
//  Created by TOO on 23/06/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "UIViewController+Alerts.h"

@implementation UIViewController (Alerts)

- (void)presentInfoAlertWithTitle:(NSString *)title message:(NSString *)text
{
    [self presentActionAlertWithTitle:title message:text action:nil];

}

- (void)presentActionAlertWithTitle:(NSString *)title message:(NSString *)text
                             action:(void (^)(UIAlertAction *action))handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:handler]];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
