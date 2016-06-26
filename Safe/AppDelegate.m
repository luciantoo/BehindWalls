//
//  AppDelegate.m
//  Safe
//
//  Created by Lucian Todorovici on 14/01/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/SignIn.h>
#import "BasicAuthenticationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

//deprecated
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    //handle application shortcuts
    
    
    if([shortcutItem.type isEqualToString:@"com.too.Safe.thermal_pic"]){
        //firstly, the user has to login
        UIViewController *takeThermalPictureVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        BasicAuthenticationViewController *loginNavigationVC = (BasicAuthenticationViewController*)[[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"fingerprintVC"];
        loginNavigationVC.authenticationCompletionBlock = ^(){
            [self.window.rootViewController presentViewController:takeThermalPictureVC animated:YES completion:^(){
                UITabBarController *tabBarController = (UITabBarController *)takeThermalPictureVC;
                [tabBarController setSelectedIndex:1];
            }];
        };
        self.window.rootViewController = loginNavigationVC;
    }
}


@end
