//
//  RoomViewController.m
//  Milk
//
//  Created by Lucian Todorovici on 27/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "RoomViewController.h"
#import "Constants.h"

@interface RoomViewController ()
@property (weak, nonatomic) IBOutlet UIButton *northWallButton;
@property (weak, nonatomic) IBOutlet UIButton *eastWallButton;
@property (weak, nonatomic) IBOutlet UIButton *southWallButton;
@property (weak, nonatomic) IBOutlet UIButton *westWallButton;
@end

@implementation RoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationViewController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:kNorthWallSegue]){
        destinationViewController.title = kNorthWallTitle;
    }else if ([segue.identifier isEqualToString:kEastWallSegue]) {
        destinationViewController.title = kEastWallTitle;
    }else if ([segue.identifier isEqualToString:kSouthWallSegue]) {
        destinationViewController.title = kSouthWallSegue;
    }else if ([segue.identifier isEqualToString:kWestWallSegue]) {
        destinationViewController.title = kWestWallTitle;
    }
}


@end
