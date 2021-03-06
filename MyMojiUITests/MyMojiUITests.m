//
//  MyMojiUITests.m
//  MyMojiUITests
//
//  Created by Xingfa Zhou on 2019/1/24.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MyMojiUITests-Swift.h"

@interface MyMojiUITests : XCTestCase

@end

@implementation MyMojiUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

    XCUIApplication *app = [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:app];
    [app launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    XCUIElementQuery *tabBarsQuery = [[XCUIApplication alloc] init].tabBars;
    XCUIElement *kaomojiButton = [tabBarsQuery.buttons elementBoundByIndex:0];
    [kaomojiButton tap];
    [Snapshot snapshot:@"Kaomoji" timeWaitingForIdle:10];

    
    XCUIElement *favoritesButton = [tabBarsQuery.buttons elementBoundByIndex:1];
    [favoritesButton tap];

    [Snapshot snapshot:@"Favorites" timeWaitingForIdle:10];
    
    
    
    XCUIElement *settingsButton = [tabBarsQuery.buttons elementBoundByIndex:2] ;
    [settingsButton tap];

    [Snapshot snapshot:@"Settings" timeWaitingForIdle:10];
}

@end
