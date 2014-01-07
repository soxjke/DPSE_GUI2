//
//  DPSettings.h
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/5/14.

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

#import <Foundation/Foundation.h>
#import "DPSettingsManager.h"

#pragma mark - COLORS

#define SERVER_HOSTNAME                     SETTINGS_MANAGER[@"Network/SSH/ServerHostname"]
#define SERVER_HOSTNAME_DEFAULT             @"neclus.donntu.edu.ua"

#define NODE_INNER_COLOR                    SETTINGS_MANAGER[@"ColorScheme/EditScreen/NodeInnerColor"]
#define NODE_INNER_COLOR_DEFAULT            [UIColor nodeInnerColorDefault]
#define NODE_OUTER_COLOR                    SETTINGS_MANAGER[@"ColorScheme/EditScreen/NodeOuterColor"]
#define NODE_OUTER_COLOR_DEFAULT            [UIColor nodeOuterColorDefault]
#define NET_COLOR                           SETTINGS_MANAGER[@"ColorScheme/EditScreen/NetColor"]
#define NET_COLOR_DEFAULT                   [UIColor netColorDefault]

#define NODE_INNER_RADIUS                   SETTINGS_MANAGER[@"UI/EditScreen/NodeInnerRadius"]
#define NODE_INNER_RADIUS_DEFAULT           @(21.f)
#define NODE_BORDER_WIDTH                   SETTINGS_MANAGER[@"UI/EditScreen/NodeBorderWidth"]
#define NODE_BORDER_WIDTH_DEFAULT           @(3.f)
#define NET_WIDTH                           SETTINGS_MANAGER[@"UI/EditScreen/NetWidth"]
#define NET_WIDTH_DEFAULT                   @(6.0f)

#define IS_CONCENTRATED_PARAMETERS          SETTINGS_MANAGER[@"Modelling/Parameters/IsConcentratedParameters"]
#define IS_CONCENTRATED_PARAMETERS_DEFAULT  @YES

void setDefaults();