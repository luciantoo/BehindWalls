//
//  LoginViewController.m
//  Milk
//
//  Created by Lucian Todorovici on 25/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "LoginViewController.h"
@import LocalAuthentication;

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self authenticate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)authenticate
{
    LAContext *authenticationContext = [[LAContext alloc] init];
    NSError *error = nil;
    
    if(![authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]){
        [self handleAutheticationError:error];
    }else{
        
        [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Please, authenticate!" reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(success && !error){
                    NSLog(@"Success!");
                }else{
                    [self handleAutheticationError:error];
                }
            });
        }];
        
    }
    
}


-(void)handleAutheticationError:(NSError*)error
{
    if(error){
        NSString *messageString = nil;
        switch (error.code) {
            case LAErrorUserCancel:
                messageString = @"You did not authenticate.";
                break;
            case LAErrorPasscodeNotSet:
                messageString = @"Cannot authenticate.Your device has no passcode set.";
                break;
            case LAErrorTouchIDNotEnrolled:
                messageString = @"Cannot authenticate.There is no registered fingerprint.";
                break;
            case LAErrorTouchIDLockout:
                messageString = @"TouchID blocked.Please provide device PIN";
                break;
            default:
                break;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authentication" message:messageString preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"segue" source:self destination:loginViewController performHandler:^(){
                [self presentViewController:loginViewController animated:YES completion:nil];
            }];
            [segue perform];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

@end
