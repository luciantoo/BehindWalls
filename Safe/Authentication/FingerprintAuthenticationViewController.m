//
//  LoginViewController.m
//  Milk
//
//  Created by Lucian Todorovici on 25/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "FingerprintAuthenticationViewController.h"
@import LocalAuthentication;

@interface FingerprintAuthenticationViewController ()

@end

@implementation FingerprintAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -AuthProtocol-

-(void)authenticate
{
    LAContext *authenticationContext = [[LAContext alloc] init];
    NSError *error = nil;
    
    if(![authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]){
        [self handleAutheticationError:error];
    }else{
        
        [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"Please, authenticate!" reply:^(BOOL success, NSError * _Nullable error) {
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

#pragma mark -Error handlind-

-(void)handleAutheticationError:(NSError*)error
{
    void (^authenticationHandler)(UIAlertAction * _Nonnull action);
    
    if(error){
        NSString *messageString = nil;
        switch (error.code) {
            case LAErrorAuthenticationFailed:
                messageString = @"Invalid credentials";
                break;
            case LAErrorUserFallback:
                {
                    messageString = @"Will authenticate via password";
                    authenticationHandler = ^(UIAlertAction * _Nonnull action){
                        [self authenticate];
                    };
                }
                break;
            case LAErrorUserCancel:
                {
                    messageString = @"You did not authenticate.";
                    [self authenticate];
                }
                break;
            case LAErrorPasscodeNotSet:
                {
                    messageString = @"Cannot authenticate.Your device has no passcode set.";
                    authenticationHandler = ^(UIAlertAction * _Nonnull action){
                        //the touch id is blocked , provide the device PIN
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                }
                break;
            case LAErrorTouchIDNotEnrolled:
                {
                    messageString = @"Cannot authenticate.There is no registered fingerprint.";
                    authenticationHandler = ^(UIAlertAction * _Nonnull action){
                        //there is not touch id registered , got to the settings application
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    };
                }
                break;
            case LAErrorTouchIDLockout:
                {
                    messageString = @"TouchID blocked.Please provide device PIN";
                    authenticationHandler = ^(UIAlertAction * _Nonnull action){
                        //the touch id is blocked , provide the device PIN
                        [self authenticate]; // the method will display by default the password unlock screen
                    };
                }
                break;
            case LAErrorTouchIDNotAvailable:
                {
                    messageString = @"TouchID not available on this device";
                    authenticationHandler = ^(UIAlertAction * _Nonnull action){
                        //the fingerprint reader is not available on this device, so use an alternate method
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                }
                break;
            case LAErrorSystemCancel:
                [self authenticate];
                break;
            case LAErrorInvalidContext:
                [self authenticate];
                break;
            default:
                break;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authentication" message:messageString preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:authenticationHandler]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

@end
