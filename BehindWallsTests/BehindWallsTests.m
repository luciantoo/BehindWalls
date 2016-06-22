//
//  BehindWallsTests.m
//  BehindWallsTests
//
//  Created by Lucian Todorovici on 22/06/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherManager.h"
#import "ColorDetector.h"

@interface WeatherManager (Test)
- (long int)extractTemperatureFromResponseData:(NSData*)data error:(NSError**)error;
@end


@interface BehindWallsTests : XCTestCase
@property(strong,nonatomic) WeatherManager *weatherManager;
@property(strong,nonatomic) ColorDetector *colorDetector;
@end

@implementation BehindWallsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _weatherManager = [WeatherManager sharedInstance];
    _colorDetector = [ColorDetector new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Weather manager tests -
- (void)testEmptyJSON
{
    NSError *error;
    long int temp = [_weatherManager extractTemperatureFromResponseData:[NSData new] error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(YES, [[error localizedDescription] isEqualToString:@"The data couldn’t be read because it isn’t in the correct format."]);
    XCTAssertEqual(LONG_MIN,temp);
}

- (void)testInvalidJSON
{
    NSError *error;
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"WeatherJSON-Malformed" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    long int temp = [_weatherManager extractTemperatureFromResponseData:jsonData error:&error];
    XCTAssertNotNil(error);
    XCTAssertEqual(YES, [[error localizedDescription] isEqualToString:MalformedJSONErrorDescription]);
    XCTAssertEqual(LONG_MIN,temp);
}

- (void)testValidJSON20000
{
    NSError *error;
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"WeatherJSON-Max" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    long int temp = [_weatherManager extractTemperatureFromResponseData:jsonData error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(20000,temp);
}

- (void)testValidJSONNegative
{
    NSError *error;
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"WeatherJSON-Neg" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    long int temp = [_weatherManager extractTemperatureFromResponseData:jsonData error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(-1234,temp);
}

#pragma mark - Color detector tests -
- (void)testWhite
{
    UIImage *target = [self generateImageWithColor:[UIColor whiteColor]];
    [_colorDetector ]
}

- (void)testBlack
{
    UIImage *target = [self generateImageWithColor:[UIColor blackColor]];
}

- (void)testRed
{
    UIImage *target = [self generateImageWithColor:[UIColor redColor]];
}

- (void)testGreen
{
    UIImage *target = [self generateImageWithColor:[UIColor greenColor]];
}

- (void)testBlue
{
    UIImage *target = [self generateImageWithColor:[UIColor blueColor]];
}

-(UIImage*)generateImageWithColor:(UIColor*)color
{
    CIImage *colorImage = [CIImage imageWithColor:color.CIColor];
    return [UIImage imageWithCIImage:colorImage];
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
