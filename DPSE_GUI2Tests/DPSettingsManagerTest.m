//
//  DPSettingsManagerTest.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/6/14.

//    Copyright (c) 2014 Petro Korienev. All rights reserved. 

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
#import "DPSettings.h"
#import "DPSettingsManager.h"

@interface DPSettingsManagerTest : XCTestCase
{
    NSUserDefaults *defaults;
    NSDictionary   *dict;
}

@end

@implementation DPSettingsManagerTest

- (void)setUp
{
    defaults = [NSUserDefaults standardUserDefaults];
    
    dict = [defaults objectForKey:appSettingsKey];
    
    [defaults removeObjectForKey:appSettingsKey];
    
    [defaults synchronize];
}

- (void)tearDown
{
    [defaults setObject:dict forKey:appSettingsKey];
    
    [defaults synchronize];
}

- (void)testExample
{
    NSMutableArray *uuids = [[NSMutableArray alloc] initWithCapacity:7];
    for (int i = 0; i < 7; i++)
    {
        uuids[i] = [[NSUUID UUID] UUIDString];
    }
    
    SETTINGS_MANAGER[uuids[0]] = uuids[1];
    if (![SETTINGS_MANAGER[uuids[0]] isEqual:uuids[1]]) XCTFail(@"simple write/read settings failed");
    
    SETTINGS_MANAGER[PATH(uuids[2], uuids[3])] = uuids[4];
    if (![SETTINGS_MANAGER[PATH(uuids[2], uuids[3])] isEqual:uuids[4]]) XCTFail(@"2-level path write/read settings failed");
    
    SETTINGS_MANAGER[PATH(uuids[2])] = uuids[4];
    if ([SETTINGS_MANAGER[PATH(uuids[2], uuids[3])] isEqual:uuids[4]]) XCTFail(@"1-level overwrite of 2-level path write/read settings failed");
    
    SETTINGS_MANAGER[PATH(uuids[2], uuids[3])] = uuids[4];
    if ([SETTINGS_MANAGER[uuids[2]] isEqual:uuids[4]]) XCTFail(@"2-level overwrite of 1-level path write/read settings failed");
    
    SETTINGS_MANAGER[PATH(uuids[2], uuids[5])] = uuids[6];
    if (![SETTINGS_MANAGER[PATH(uuids[2], uuids[5])] isEqual:uuids[6]]) XCTFail(@"2-level addition path write/read settings failed");
}

@end
