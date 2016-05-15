//
//  ProfileViewController.m
//  Milk
//
//  Created by Lucian Todorovici on 25/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property(strong,nonatomic) CLLocationManager *locationManager;
@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    // the user has not made a decision regarding the location services
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager startUpdatingLocation];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Location manager delegate -

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // user has accepted using the location services
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // let's get the current location , show it visually to the user
        [_locationManager startUpdatingLocation];
    }else {
        //show we cannot use location services
        
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //fetch last updated location
    CLLocation *lastLocation = [locations lastObject];
    //decode the location of the user from coordinates to city name and location
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:lastLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(!error){
            CLPlacemark *placemark = [placemarks lastObject];
            //update the UI with the new data , it must take place on the main thread
            
        }
    }];
}

@end
