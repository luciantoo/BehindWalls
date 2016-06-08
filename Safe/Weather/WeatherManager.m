//
//  WeatherManager.m
//  Milk
//
//  Created by Lucian Todorovici on 27/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "WeatherManager.h"

@interface WeatherManager()
@property (assign,nonatomic) BOOL shouldRequestWeatherUpdate;
@end

@implementation WeatherManager

+(WeatherManager*)sharedInstance
{
    static dispatch_once_t once_token;
    static WeatherManager *sharedInstance;
    
    dispatch_once(&once_token, ^{
        sharedInstance = [WeatherManager new];
    });
    
    return sharedInstance;
}

- (id)init {
    if(self=[super init]){
        _shouldRequestWeatherUpdate = YES;
    }
    return self;
}


-(void)requestTemperatureForCoordinates:(CLLocationCoordinate2D)coordinates inLabel:(UILabel*)label
{
    if(_shouldRequestWeatherUpdate){
        _shouldRequestWeatherUpdate = NO;
        NSString *urlString = [NSString stringWithFormat:@"%@lat=%f&lon=%f&%@",kOpenweathermapURL,coordinates.latitude,coordinates.longitude,kOpenweathermapAPIKey];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
            if(httpResponse.statusCode == 200 && data.length > 0 && !error){ //the received response is valid and contains data
                NSError *serializationError = nil;
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
                if(responseDict && !serializationError){
                    NSDictionary *infoDict = [responseDict objectForKey:@"main"];
                    long int temperature = [[infoDict objectForKey:@"temp"] integerValue];
                    long int celsiusTemperature = temperature - 274.15;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        label.text = [NSString stringWithFormat:@"air temp: %li K (%li)",temperature,celsiusTemperature];
                    });
                    NSLog(@"Current temperature: %li",temperature);
                }else{
                    NSLog(@"Error , could not retrieve weather info");
                }
            }
        }];
        [dataTask resume];
    }
}

@end
