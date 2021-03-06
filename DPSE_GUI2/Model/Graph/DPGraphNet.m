//
//  DPGraphNet.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/3/14.

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

#import "DPGraphNet.h"

#import "DPGraphNode.h"

#import "DPAttributesManager.h"

NSString * const kFlowInertionQuotientKey   = @"K";
NSString * const kTotalResistanceKey        = @"R";
NSString * const kDeltaPressureKey          = @"H";
NSString * const kInitialFlowKey            = @"I0";

NSString * const kStartNodeKey              = @"startNode.nameLabel";
NSString * const kEndNodeKey                = @"endNode.nameLabel";

@interface DPGraphNet ()
{
    NSArray *_nodes;
}

@property (nonatomic, readonly) DPGraphNode *startNode;
@property (nonatomic, readonly) DPGraphNode *endNode;

@end

@implementation DPGraphNet

+ (instancetype)netFromNode:(DPGraphNode *)startNode toNode:(DPGraphNode *)toNode
{
    return [[self alloc] initFromNode:startNode toNode:toNode];
}

- (instancetype)initFromNode:(DPGraphNode *)startNode toNode:(DPGraphNode *)toNode
{
    self = [super init];
    if (self)
    {
        _nodes = @[startNode, toNode];
        
        [startNode connectNet:self];
        [toNode connectNet:self];
        
        self.itemAttributes[kFlowInertionQuotientKey] = @(0.001f);
        self.itemAttributes[kTotalResistanceKey]      = @(0.001f);
        self.itemAttributes[kDeltaPressureKey]        = @(0.0f);
        self.itemAttributes[kInitialFlowKey]          = @(0.0f);
        
        self.isConcentratedParameters                 = YES;
    }
    return self;
}

- (NSArray*)nodes
{
    return _nodes;
}

- (DPGraphNode*)startNode
{
    return _nodes.firstObject;
}

- (DPGraphNode*)endNode
{
    return _nodes.lastObject;
}

- (NSArray*)knownKeyPaths
{
    return self.isConcentratedParameters ? ATTRIBUTES_MANAGER.concentratedParametersNetAttributes : ATTRIBUTES_MANAGER.distributedParametersNetAttributes;
}

@end
