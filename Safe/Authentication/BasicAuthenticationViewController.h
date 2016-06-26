//
//  BasicAuthenticationViewController.h
//  Behind Walls
//
//  Created by Lucian Todorovici on 28/05/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthProtocol.h"

/**
 *  The base class for view-controllers used in authentication tasks
 */
@interface BasicAuthenticationViewController : UIViewController<AuthProtocol>
/**
 *  Block used only for 3D touch with application shortcuts with a custom flow
 */
@property(readwrite,nonatomic) void(^authenticationCompletionBlock)(void);

- (void)userAuthenticatedSuccessfully;

@end
