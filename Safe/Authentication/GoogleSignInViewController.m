//
//  GoogleSignInViewController.m
//  Behind Walls
//
//  Created by Lucian Todorovici on 20/05/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "GoogleSignInViewController.h"

@interface GoogleSignInViewController ()

@end

@implementation GoogleSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)authenticate {
    NSError *configureError = nil;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if(error){
        NSLog(@"Error:%@",error.localizedDescription);
    }else{
        NSLog(@"%@ has just signed in",user.profile.name);
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    NSLog(@"%@ has just signed out",user.profile.name);
}
@end
