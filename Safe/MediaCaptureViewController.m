//
//  MediaCaptureViewController.m
//  Milk
//
//  Created by TOO on 21/02/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "MediaCaptureViewController.h"
#import "WeatherManager.h"

@interface MediaCaptureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *captureBtn;
@property (weak, nonatomic) IBOutlet UISwitch *photoVideoSwitch;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *surfaceTemperatureLabel;

@property(strong,nonatomic) CLLocationManager *locationManager;
@end


@implementation MediaCaptureViewController

static NSString * const ALBUM_NAME = @"flir";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FLIROneSDK sharedInstance].userInterfaceUsesCelsius = YES;
    [[FLIROneSDKStreamManager sharedInstance] addDelegate:self];
    [[FLIROneSDKStreamManager sharedInstance] performTuning];
    [[FLIROneSDKStreamManager sharedInstance] setAutomaticTuning:YES];
    [FLIROneSDKStreamManager sharedInstance].imageOptions =  FLIROneSDKImageOptionsThermalRadiometricKelvinImage | FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
    
    if([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized){
        NSLog(@"Not authorized to save pictures");
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            NSLog(@"Authorized");
        }];
    }
    
    [self setupLocationManager];
    
    // add the action of saving the image when the capture button is pressed
    [self.captureBtn addTarget:self action:@selector(captureBtnPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -Actions-

-(void)captureBtnPressed
{
    if(self.imgView.image){
        [self addNewAssetWithImage:self.imgView.image toAlbum:ALBUM_NAME];
    }else{
        NSLog(@"Cannot save the image, because it is nil");
    }
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
/*
-(void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveVisualJPEGImage:(NSData *)visualJPEGImage
{
    const CGSize size = CGSizeMake(640, 480);
    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsVisualJPEGImage andData:visualJPEGImage andSize:size];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.imgView.image = image;
    });
}
 */

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveRadiometricData:(NSData *)radiometricData imageSize:(CGSize)size{
    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRadiometricKelvinImage andData:radiometricData andSize:size];
    dispatch_async(dispatch_get_main_queue(), ^{
        //create a bounding rectangle in the middle of the image 10x10
        CGFloat y = size.height/2 - 5;
        CGFloat x = size.width/2 - 5;
        CGRect probeRect = CGRectMake(x, y, 10, 10);
        uint16_t *buffer = (uint16_t*) [radiometricData bytes];
//        const int samples = probeRect.size.width*probeRect.size.height;
//        long int average = 0;
//        for (int i = probeRect.origin.x ; i < probeRect.size.width ; i++) {
//            for (int j = probeRect.origin.y ; j < probeRect.size.height ; j++) {
//                average += buffer[i*(int)probeRect.size.width+j]/100;
//            }
//        }
        int middle = (int)size.width*((int)size.height/2) + (int)size.width/2;
        float temp = ((float)buffer[middle]/100.0f);
        long int cTemp =(long int) (temp - 274.15);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.surfaceTemperatureLabel.text = [NSString stringWithFormat:@"surface temp: %.0f (%li °C)",temp,cTemp];
        });
    });
}

#pragma mark -Image saving-

- (void)addNewAssetWithImage:(UIImage *)image toAlbum:(NSString *)albumName
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // Request creating an asset from the image.
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        PHFetchOptions *fetchOptions = [PHFetchOptions new];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"localizedTitle = %@",albumName];
        
        PHFetchResult *fetchedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
        
        PHAssetCollectionChangeRequest *albumChangeRequest = nil;
        
        if(fetchedAlbums.count == 1){
            // Request editing the album if it already exists
            albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:[fetchedAlbums firstObject]];
        }else{
            //Create a new album if it does not exist
            albumChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
        
        }
        // Get a placeholder for the new asset and add it to the album editing request.
        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
        [albumChangeRequest addAssets:@[ assetPlaceholder ]];
        
    } completionHandler:^(BOOL success, NSError *error) {
        NSLog(@"Finished adding asset. %@", (success ? @"Success" : error));
    }];
}

#pragma mark -Location manager-

- (void)setupLocationManager {
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    // the user has not made a decision regarding the location services
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager startUpdatingLocation];
        [_locationManager startUpdatingHeading];
    }
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
            [[WeatherManager sharedInstance] requestTemperatureForCoordinates:placemark.location.coordinate inLabel:_temperatureLabel];
            _cityLabel.text = placemark.locality;
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    _headingLabel.text = [NSString stringWithFormat:@"%f°",newHeading.trueHeading];
}


@end
