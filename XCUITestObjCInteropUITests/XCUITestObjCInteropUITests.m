//
//  XCUITestObjCInteropUITests.m
//  XCUITestObjCInteropUITests
//
//  Created by Mykhailo Lysenko on 10/18/23.
//

#import <XCTest/XCTest.h>
#import "XCUITestObjCInteropUITests-Swift.h"
@class EvincedLauncher;

@interface XCUITestObjCInteropUITests : XCTestCase

@end

@implementation XCUITestObjCInteropUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = YES;
    
    // In `setupWithTestCase:error:` function
    NSError *error = nil;
    [EvincedLauncher setupWithTestCase:self error:&error];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

/**
 * An example of simple test that can generate report.
 * The report can be seen in test results - there you can see several attachments.
 */
- (void)testSimpleReportExample {
    
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    NSError *error = nil;
    [EvincedLauncher reportAndReturnError:&error];
    
    XCTAssertNil(error, "error occurred");
}

- (void)testAccessibility {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    NSError *error = nil;
    [EvincedLauncher analyze:app error:&error];
    
    [EvincedLauncher reportStoredAndReturnError:&error];
    XCTAssertNil(error, "There should not be error here.");
}

- (void)testAccessibilityContinuousMode {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    [EvincedLauncher startAnalyze];
    
    [app.buttons.firstMatch tap];
    
    [EvincedLauncher stopAnalyze];
    
    NSError *error = nil;
    [EvincedLauncher reportStoredAndReturnError:&error];
    XCTAssertNil(error, "There should not be error here.");
}

/**
 * An example shows how Evinced can be configured for specific use cases.
 */
- (void)testOnlyColorContrastExample {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    NSError *error = nil;
    [EvincedLauncher verifyColorContrastAndReturnError:&error];
    
    XCTAssertNil(error, "There should not be error here.");
}

@end
