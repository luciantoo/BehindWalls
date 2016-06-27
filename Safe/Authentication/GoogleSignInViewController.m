//
//  GoogleSignInViewController.m
//  Behind Walls
//
//  Created by Lucian Todorovici on 20/05/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "GoogleSignInViewController.h"
#import "UIViewController+Alerts.h"

@interface GoogleSignInViewController ()

@end

@implementation GoogleSignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)authenticate
{
    NSError *configError = nil;
    [[GGLContext sharedInstance] configureWithError:&configError];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    if(error){
        DDLogWarn(@"Google authentication -> Failed: %@",error.localizedDescription);
        NSString *message = [NSString stringWithFormat:@"Facebook Login failed: %@", [error localizedDescription]];
        [self presentActionAlertWithTitle:@"Failed" message:message action:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }else{
        DDLogInfo(@"Google authentication -> User:%@ has just signed in",user.profile.name);
        [super userAuthenticatedSuccessfully];
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    DDLogInfo(@"%@ has just signed out",user.profile.name);
}
@end
