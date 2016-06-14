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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self authenticate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)userAuthenticatedSuccessfully {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainViewController = [mainStoryboard instantiateInitialViewController];
    [self presentViewController:mainViewController animated:YES completion:^{
        delegate.window.rootViewController = mainViewController;
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
