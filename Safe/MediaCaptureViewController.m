//
//  MediaCaptureViewController.m
//  Milk
//
//  Created by TOO on 21/02/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "MediaCaptureViewController.h"

@interface MediaCaptureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *captureBtn;
@property (weak, nonatomic) IBOutlet UISwitch *photoVideoSwitch;

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
    [FLIROneSDKStreamManager sharedInstance].imageOptions = FLIROneSDKImageOptionsThermalRadiometricKelvinImage;
    
    if([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized){
        NSLog(@"Not authorized to save pictures");
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            NSLog(@"Authorized");
        }];
    }
    
    [self.captureBtn addTarget:self action:@selector(captureBtnPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -Actions-
-(void)captureBtnPressed
{
    self.imgView.image = [UIImage imageNamed:@"milk.jpg"];
    [self addNewAssetWithImage:self.imgView.image toAlbum:ALBUM_NAME];
}

#pragma mark -Image delegate-
-(void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveVisualJPEGImage:(NSData *)visualJPEGImage
{
    const CGSize size = CGSizeMake(640, 480);
    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsVisualJPEGImage andData:visualJPEGImage andSize:size];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.imgView.image = image;
    });
}

- (void) FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveRadiometricData:(NSData *)radiometricData imageSize:(CGSize)size{
    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRadiometricKelvinImage andData:radiometricData andSize:size];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imgView.image = image;
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


@end
