//
//  DPSSHConnection.m
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


#import "DPSSHConnection.h"
#import <NMSSH/NMSSH.h>

#define COMPLETE1(block, param1) \
do \
{ \
    typeof (param1) _param1 = [param1 copy]; \
    dispatch_async(self.completionQueue, ^() \
    { \
        block(_param1); \
    }); \
} \
while (0);

#define COMPLETE2(block, param1, param2) \
do \
{ \
    typeof (param1) _param1 = [param1 copy]; \
    typeof (param2) _param2 = [param2 copy]; \
    dispatch_async(self.completionQueue, ^() \
    { \
        block(_param1, _param2); \
    }); \
} \
while (0);

NSString * const defaultServerHostname  = @"neclus.donntu.edu.ua";
NSString * const defaultUsername        = @"student";
NSString * const defaultPassword        = @"stud2013";

NSInteger const defaultTimeout          = 10;

@interface DPSSHConnection () <NMSSHSessionDelegate>
{
    dispatch_queue_t    _connectionQueue;
    NMSSHSession        *_session;
    DPConnectionState   _connectionState;
    NSError             *_occuredError;
}

@end

@implementation DPSSHConnection

+ (instancetype)sharedObject
{
    static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void)
    {
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _connectionQueue = dispatch_queue_create("com.petrokorienev.dispatchQueue.DPSSHConnection", DISPATCH_QUEUE_SERIAL);
        self.completionQueue = dispatch_get_global_queue(0, 0);
        
        self.hostname = defaultServerHostname;
        self.username = defaultUsername;
        self.password = defaultPassword;
        
        self.timeout  = defaultTimeout;
    }
    return self;
}

- (void)connectWithCompletion:(DPConnectionSuccessErrorBlock)completion;
{
    DPConnectionSuccessErrorBlock completionBlock = [completion copy];

    _connectionState    = DPConnectionStateConnecting;
    _occuredError       = nil;
    
    dispatch_async(_connectionQueue, ^(void)
    {
        _session = [[NMSSHSession alloc] initWithHost:self.hostname andUsername:self.username];
        
        _session.delegate = self;
        
        [_session connectWithTimeout:@(self.timeout)];
        
        if (_session.isConnected)
        {
            [_session authenticateByPassword:self.password];
            if (_session.isAuthorized)
            {
                _connectionState = DPConnectionStateConnectedIdle;
                COMPLETE1(completionBlock, _occuredError);
                completionBlock(nil);
            }
            else
            {
                [_session disconnect];
                COMPLETE1(completionBlock, [NSError new]);
            }
        }
        else
        {
            _connectionState = DPConnectionStateDisconnected;
            COMPLETE1(completionBlock, [NSError new]);
        }
    });
}

- (void)disconnect
{
    [_session disconnect];
}

#pragma mark - NMSSHSessionDelegate

- (void)session:(NMSSHSession *)session didDisconnectWithError:(NSError *)error
{
    _connectionState    = DPConnectionStateDisconnected;
    _occuredError       = [error copy];
}

- (NSString *)session:(NMSSHSession *)session keyboardInteractiveRequest:(NSString *)request
{
    NSAssert(NO, @"Server has sent unexpected keyboardInteractiveRequest:\n%@", request);
    return nil;
}

@end
