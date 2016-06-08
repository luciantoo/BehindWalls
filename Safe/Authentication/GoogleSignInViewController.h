//
//  GoogleSignInViewController.h
//  Behind Walls
//
//  Created by Lucian Todorovici on 20/05/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicAuthenticationViewController.h"
#import <Google/SignIn.h>

/**
 *  View-controller for Google Sign In
 */
@interface GoogleSignInViewController : BasicAuthenticationViewController<GIDSignInDelegate,GIDSignInUIDelegate>

@end
