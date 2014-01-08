//
//  DPConcentratedParametersSimulationOperation.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/8/14.

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


#import "DPConcentratedParametersSimulationOperation.h"

#import "DPGraph.h"
#import "DPGraphNet.h"
#import "DPGraphNode.h"

#define LOG(fmt, ...) if (self.logBlock) dispatch_async(dispatch_get_main_queue(), ^(void) {self.logBlock(self, [NSString stringWithFormat:fmt, ##__VA_ARGS__]);})

@interface DPConcentratedParametersSimulationOperation ()

@property (nonatomic, copy) DPConcentratedParametersSimulationOperationLogBlock logBlock;
@property (nonatomic, copy) DPConcentratedParametersSimulationOperationCompletionBlock operationCompletion;

@property (nonatomic, strong) DPGraph *graph;

@property (nonatomic, strong) NSMutableArray *minimalSpanningTree;
@property (nonatomic, strong) NSMutableArray *antiTree;

@end

@implementation DPConcentratedParametersSimulationOperation

- (instancetype)initWithGraph:(DPGraph*)graph
                     logBlock:(DPConcentratedParametersSimulationOperationLogBlock)logBlock
              completionBlock:(DPConcentratedParametersSimulationOperationCompletionBlock)completionBlock
{
    self = [super init];
    if (self)
    {
        self.logBlock = logBlock;
        self.operationCompletion = completionBlock;
        
        self.graph = graph;
    }
    return self;
}

- (void)main
{
//    [self parseGraph];
    [self topologyAnalyze];
    [self equationsGeneration];
    [self equationsSolving];
    if (self.operationCompletion)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            self.operationCompletion(self, nil);
        });
    }

}

- (void)parseGraph
{
    LOG(@"\nParsing graph...\n");
    LOG(@"\nParsed successfully...\n");
}

- (void)topologyAnalyze
{
    LOG(@"\nTopology analyze...\n");
    [self primsAlgorithm];
    
    LOG(@"\nTopology analyzed successfully...\n");
}

- (void)equationsGeneration
{
    LOG(@"\nEquations generation...\n");
    LOG(@"\nEquations generated successfully...\n");
}

- (void)equationsSolving
{
    LOG(@"\nEquations solution...\n");
    LOG(@"\nEquations solved successfully...\n");
}

- (void)checkConnectivity
{
    LOG(@"\nChecking given graph's connectivity...\n");
    LOG(@"\nGraph is connective...\n");
}

- (void)primsAlgorithm
{
    LOG(@"\nRunning prihm's alghorithm to get minimum spanning tree...\n");
    
    NSMutableArray *minimalSpanningTreeNodes = [NSMutableArray arrayWithCapacity:self.graph.nodes.count];
    
    self.minimalSpanningTree = [NSMutableArray arrayWithCapacity:self.graph.nodes.count - 1];
    
    [minimalSpanningTreeNodes addObject:self.graph.nodes[0]];
    
    for (int i = 0; i < self.graph.nodes.count - 1; i++)
    {
        [minimalSpanningTreeNodes enumerateObjectsUsingBlock:^(DPGraphNode *treeNode, NSUInteger idx, BOOL *outerStop)
        {
            [treeNode.nets enumerateObjectsUsingBlock:^(DPGraphNet *connectedNet, NSUInteger idx, BOOL *innerStop)
            {
                DPGraphNode *connectedNode = [treeNode isEqual:connectedNet.nodes.firstObject] ? connectedNet.nodes.lastObject : connectedNet.nodes.firstObject;
                
                if ([minimalSpanningTreeNodes indexOfObject:connectedNode] == NSNotFound)
                {
                    [minimalSpanningTreeNodes addObject:connectedNode];
                    [self.minimalSpanningTree addObject:connectedNet];
                    *innerStop = YES;
                    *outerStop = YES;
                }
            }];
        }];
    }
    
    NSLog(@"Minimal spanning tree nodes:\n%@", minimalSpanningTreeNodes);
    NSLog(@"Minimal spanning tree:\n%@", self.minimalSpanningTree);
    
    LOG(@"\nMinimum spanning tree found successfully...\n");
}

@end
