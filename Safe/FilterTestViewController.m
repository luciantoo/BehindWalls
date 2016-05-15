//
//  FilterTestViewController.m
//  Milk
//
//  Created by TOO on 13/03/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "FilterTestViewController.h"
#import "SobelFilter.h"

@interface FilterTestViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation FilterTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.imgView setImage:[UIImage imageNamed:@"test_f2"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)convertBtnPressed:(id)sender {
    UIImage *img = [UIImage imageNamed:@"test_f2"];
    SobelFilter *filter = [SobelFilter new];
    UIImage *filteredImg = [filter filteredImageFromImage:img];
    [self.imgView setImage:filteredImg];
}

@end
