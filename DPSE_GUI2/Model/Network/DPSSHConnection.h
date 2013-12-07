//
//  DPSSHConnection.h
//  DPSE_GUI2
//
//  Created by Petro Korienev on 12/7/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DPConnectionSuccessErrorBlock)(NSError* error);

typedef NS_ENUM(NSUInteger, DPConnectionState)
{
    DPConnectionStateDisconnected,
    DPConnectionStateConnecting,
    DPConnectionStateConnectedIdle,
    DPConnectionStateConnectedBusy
};

@interface DPSSHConnection : NSObject

+ (instancetype)sharedObject;

- (void)connectWithCompletion:(DPConnectionSuccessErrorBlock)completion;
- (void)disconnect;

@property (nonatomic) NSString *hostname;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) NSInteger timeout;

@property dispatch_queue_t completionQueue;

@end
