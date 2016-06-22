//
//  FacebookAuthViewController.m
//  Behind Walls
//
//  Created by Lucian Todorovici on 19/05/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "FacebookAuthViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FacebookAuthViewController ()

@end

@implementation FacebookAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -AuthProtocol-

- (void)authenticate
{
    FBSDKLoginManager *loginManager = [FBSDKLoginManager new];
    [loginManager logInWithReadPermissions:@[@"email",@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if(!error) {
            if(!result.isCancelled){
                if(result.token){
                    DDLogInfo(@"Fb Authentication -> Success");
                    return;
                }
            }
        }
        DDLogWarn(@"Fb Authentication -> Failed");
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login_error_vc"];
        //(*ErrorViewController) controller
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

@end
