//
//  DPConnectionTest.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 12/7/13.

//    Copyright (c) 2013 Petro Korienev. All rights reserved.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


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
            if ([APP_DELEGATE isHostReachable])
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
