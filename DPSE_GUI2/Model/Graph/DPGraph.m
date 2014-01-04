//
//  DPGraph.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/4/14.

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


#import "DPGraph.h"
#import "DPGraphNode.h"
#import "DPGraphNet.h"

@interface DPGraph ()
{
    NSMutableArray *_nodes;
    NSMutableArray *_nets;
}

@end

@implementation DPGraph

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _nodes = [NSMutableArray new];
        _nets  = [NSMutableArray new];
    }
    return self;
}

- (void)addNode:(CGPoint)nodeLocation
{
    [_nodes addObject:[DPGraphNode nodeWithLocation:nodeLocation]];
}

- (void)addNetFromNode:(DPGraphNode*)startNode toNode:(DPGraphNode*)endNode
{
    DPGraphNet *net = [DPGraphNet netFromNode:startNode toNode:endNode];
    
    [startNode  connectNet:net];
    [endNode    connectNet:net];
    
    [_nets addObject:net];
}

- (void)removeNode:(DPGraphNode*)node
{
    [node.nets enumerateObjectsUsingBlock:^(DPGraphNet *net, NSUInteger idx, BOOL *stop)
     {
         [_nets removeObject:net];
         
         [net.nodes enumerateObjectsUsingBlock:^(DPGraphNode *connectedNode, NSUInteger idx, BOOL *stop)
          {
              [connectedNode disconnectNet:net];
          }];
     }];
    
    [_nodes removeObject:node];
}

- (void)removeNet:(DPGraphNet*)net
{
    [net.nodes enumerateObjectsUsingBlock:^(DPGraphNode *connectedNode, NSUInteger idx, BOOL *stop)
     {
         [connectedNode disconnectNet:net];
     }];
    
    [_nets removeObject:net];
}

#pragma mark - setter/getter

- (NSArray*)nets
{
    return [_nets copy];
}

- (NSArray*)nodes
{
    return [_nodes copy];
}

@end
