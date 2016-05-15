//
//  MilkAlertViewController.m
//  Safe
//
//  Created by Lucian Todorovici on 14/01/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "MilkAlertViewController.h"
#import <FLIROneSDK/FLIROneSDKSimulation.h>
#import "ThermalProcessingUnit.h"
#import <AudioToolbox/AudioToolbox.h>

#define SOUND_ID 1325

@interface MilkAlertViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *startTimerBtn;
@property (weak, nonatomic) IBOutlet UIView *crosshairBlurView;
@property (weak, nonatomic) IBOutlet UILabel *reachedLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong,nonatomic) ThermalProcessingUnit *tpu;
@end

@implementation MilkAlertViewController
{
    int reachCounter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[FLIROneSDKSimulation sharedInstance] connectWithFrameBundleName:@"sampleframes_hq" withBatteryChargePercentage:@42];
    [FLIROneSDK sharedInstance].userInterfaceUsesCelsius = YES;
    [[FLIROneSDKStreamManager sharedInstance] addDelegate:self];
    [[FLIROneSDKStreamManager sharedInstance] performTuning];
    [[FLIROneSDKStreamManager sharedInstance] setAutomaticTuning:YES];
    [FLIROneSDKStreamManager sharedInstance].imageOptions = FLIROneSDKImageOptionsBlendedMSXRGBA8888Image | FLIROneSDKImageOptionsThermalRadiometricKelvinImage;
    _tpu = [[ThermalProcessingUnit alloc] initWithTargetTemperature:53.0];
    reachCounter = 0;
//        self.crosshairBlurView.clipsToBounds = NO;
    self.crosshairBlurView.layer.cornerRadius = 25.0f;
    self.crosshairBlurView.layer.masksToBounds = YES;
    self.crosshairBlurView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -Actions-
- (IBAction)startBtnPressed:(UIButton *)sender {
    reachCounter = 0;
    self.reachedLabel.hidden = YES;
}


#pragma mark -Image delegate-
- (void) FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveBlendedMSXRGBA8888Image:(NSData *)msxImage imageSize:(CGSize)size {
    //render the image
    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsBlendedMSXRGBA8888Image andData:msxImage andSize:size];
    
    //perform ui update on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imgView.image = image;
    });
}

- (void) FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveRadiometricData:(NSData *)radiometricData imageSize:(CGSize)size{
    
    if([_tpu isTargetTemperatureReached:radiometricData size:size updateView:_tempLabel]){
        reachCounter ++;
    }
    if(reachCounter > 3){
        //perform ui update on main thread
        reachCounter = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reachedLabel.hidden = NO;
            AudioServicesPlaySystemSound(SOUND_ID);
        });

    }
//    //render the image
//    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRadiometricKelvinImage andData:radiometricData andSize:size];
}

#pragma mark -SDK delegate-

- (void) FLIROneSDKDidConnect {
    //get the main thread
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.startTimerBtn setTitle:@"Start(connected)" forState:UIControlStateNormal];
    });
}

- (void) FLIROneSDKDidDisconnect {
    //get the main thread
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.startTimerBtn setTitle:@"Start(disconnected)" forState:UIControlStateNormal];
    });
}


@end
