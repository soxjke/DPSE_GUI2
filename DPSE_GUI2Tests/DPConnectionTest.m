//
//  DPConnectionTest.m
//  DPSE_GUI2
//
//  Created by Petro Korienev on 12/7/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#import <XCTest/XCTest.h>

#define TIMEOUT_STEP            2
#define NUM_OF_TIMEOUT_STEPS    5

@interface DPConnectionTest : XCTestCase

@end

@implementation DPConnectionTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
    DPSSHConnection *connection = [DPSSHConnection sharedObject];
    if (!connection)
    {
        XCTFail("Connection unitializable");
    }
    
    NSString *defaultHostname = connection.hostname;
    NSInteger defaultTimeout  = connection.timeout;
    
    connection.hostname = @"www.google.com";
    
    for (NSInteger index = 1; index <= NUM_OF_TIMEOUT_STEPS; index++)
    {
        dispatch_semaphore_t dsema = dispatch_semaphore_create(0);
        
        connection.timeout = index * TIMEOUT_STEP;
        
        [connection connectWithCompletion:^(NSError *error)
        {
            if (!error)
            {
                XCTFail(@"Connection didn't return error for unreachable host");
            }
            dispatch_semaphore_signal(dsema);
        }];
        
        if (dispatch_semaphore_wait(dsema, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * (index * TIMEOUT_STEP + 1))))
        {
            XCTFail("Connection doesn't pass timeout requirements test");
        }
    }
    
    connection.hostname = defaultHostname;
    connection.timeout = defaultTimeout;
    
    NSString *defaultPassword = connection.password;
    
    dispatch_semaphore_t dsema = dispatch_semaphore_create(0);
    
    connection.password = @"Vrotmnenogi";
    
    [connection connectWithCompletion:^(NSError *error)
    {
        if (!error)
        {
            XCTFail(@"Connection didn't return error for wrong password");
        }
        dispatch_semaphore_signal(dsema);
    }];
    
    if (dispatch_semaphore_wait(dsema, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * (defaultTimeout + 1))))
    {
        XCTFail("Connection timeout condition fail");
    }
    
    connection.password = defaultPassword;
    
    dsema = dispatch_semaphore_create(0);
    
    [connection connectWithCompletion:^(NSError *error)
    {
        if (!error)
        {
            if ([((DPAppDelegate*)[[UIApplication sharedApplication] delegate]) isHostReachable])
            {
                XCTFail(@"Connection didn't return error for wrong password");
            }
        }
        dispatch_semaphore_signal(dsema);
    }];
    
    if (dispatch_semaphore_wait(dsema, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * (defaultTimeout + 1))))
    {
        XCTFail("Connection timeout condition fail");
    }
}

@end
