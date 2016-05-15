//
//  WeatherManager.m
//  Milk
//
//  Created by Lucian Todorovici on 27/04/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "WeatherManager.h"

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

-(void)requestTemperatureForLocation
{
    NSString *urlString = @"";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
        if(httpResponse.statusCode == 200 && data.length > 0 && !error){ //the received response is valid and contains data
            NSError *serializationError = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
            if(responseDict && !serializationError){
                
            }else{
                NSLog(@"");
            }
        }
    }];
    [dataTask resume];
}

@end
