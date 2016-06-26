//
//  BasicAuthenticationViewController.m
//  Behind Walls
//
//  Created by Lucian Todorovici on 28/05/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "BasicAuthenticationViewController.h"
#import "AppDelegate.h"

@interface BasicAuthenticationViewController ()

@end

@implementation BasicAuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self authenticate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


/**
 *  The method is called by subclasses when the authentication is successful.
 *  The main view controller will be displayed and will become the root view-controller
 */
- (void)userAuthenticatedSuccessfully
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainViewController = [mainStoryboard instantiateInitialViewController];
    if(!self.authenticationCompletionBlock){
        [self presentViewController:mainViewController animated:YES completion:^{
            delegate.window.rootViewController = mainViewController;
        }];
    }else{
        self.authenticationCompletionBlock();
    }
}

@end
