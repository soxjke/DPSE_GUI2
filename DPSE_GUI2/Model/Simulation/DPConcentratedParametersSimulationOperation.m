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

@property (nonatomic) CGFloat *incidenceMatrixTree;
@property (nonatomic) CGFloat *meshMatrixTree;
@property (nonatomic) CGFloat *incidenceMatrixAntitree;
@property (nonatomic) CGFloat *meshMatrixAntitree;

@property (nonatomic) NSURL *workingDirectoryURL;

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
    NSError *error;
    
    self.workingDirectoryURL = [APP_DELEGATE.applicationDocumentsDirectory URLByAppendingPathComponent:[[NSUUID UUID] UUIDString]];
    [[NSFileManager defaultManager] createDirectoryAtURL:self.workingDirectoryURL withIntermediateDirectories:NO attributes:nil error:&error];
    
    if (!error)
    {
        [self topologyAnalyze];
        [self equationsGeneration];
        [self equationsSolving];
    }
    
    if (self.operationCompletion)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            self.operationCompletion(self, nil);
        });
    }

}

- (void)topologyAnalyze
{
    LOG(@"\nTopology analyze...\n");

    [self primsAlgorithm];

    self.antiTree = [self.graph.nets mutableCopy];
    [self.antiTree removeObjectsInArray:self.minimalSpanningTree];
    
    NSUInteger n = self.graph.nodes.count;
    NSUInteger m = self.graph.nets.count;
    
    self.incidenceMatrixTree        = malloc((n - 1) * (n - 1) * sizeof(CGFloat));
    self.incidenceMatrixAntitree    = malloc((n - 1) * (m - n + 1) * sizeof(CGFloat));
    
    __block NSUInteger currentNetIdx;
    __block DPGraphNet *net;
    __block CGFloat *incidenceMatrix;
    __block NSUInteger currentMatrixCols;
    
    void(^nodeEnumerator)(DPGraphNode *node, NSUInteger nodeIdx, BOOL *stop) = ^(DPGraphNode *node, NSUInteger nodeIdx, BOOL *stop)
    {
        if (nodeIdx == n - 1) return;
        incidenceMatrix[currentMatrixCols * nodeIdx + currentNetIdx] = [net.nodes.firstObject isEqual:node] ? -1 : ([net.nodes.lastObject isEqual:node] ? 1 : 0);
    };

    [self.minimalSpanningTree enumerateObjectsUsingBlock:^(DPGraphNet *treeNet, NSUInteger netIdx, BOOL *stop)
    {
        currentNetIdx = netIdx;
        net = treeNet;
        incidenceMatrix = self.incidenceMatrixTree;
        currentMatrixCols = n - 1;
        [self.graph.nodes enumerateObjectsUsingBlock:nodeEnumerator];
    }];
    
    [self.antiTree enumerateObjectsUsingBlock:^(DPGraphNet *treeNet, NSUInteger netIdx, BOOL *stop)
    {
        currentNetIdx = netIdx;
        net = treeNet;
        incidenceMatrix = self.incidenceMatrixAntitree;
        currentMatrixCols = m - n + 1;
        [self.graph.nodes enumerateObjectsUsingBlock:nodeEnumerator];
    }];
    
    self.meshMatrixTree     = malloc((m - n + 1) * (n - 1) * sizeof(CGFloat));
    self.meshMatrixAntitree = malloc((m - n + 1) * (m - n + 1) * sizeof(CGFloat));
   
    NSMutableArray *meshNetsPaths = [NSMutableArray arrayWithCapacity:n - m + 1];
    NSMutableArray *meshNodesPaths = [NSMutableArray arrayWithCapacity:n - m + 1];
    
    [self.antiTree enumerateObjectsUsingBlock:^(DPGraphNet *antitreeNet, NSUInteger meshIdx, BOOL *stop)
    {
        NSMutableArray *meshNodes   = [NSMutableArray new];
        NSMutableArray *meshNets    = [NSMutableArray new];
        
        [meshNodes addObject:antitreeNet.nodes.lastObject];
        [meshNets addObject:antitreeNet];
        
        BOOL __unused foundPath = [self continuePathToNode:antitreeNet.nodes.firstObject withMeshNodes:meshNodes meshNets:meshNets];
        
        [meshNetsPaths  addObject:meshNets];
        [meshNodesPaths addObject:meshNodes];
        
        LOG(@"\nfound mesh path %@\n", meshNets);
    }];
    
    __block CGFloat *meshMatrix;
    
    void(^pathEnumerator)(DPGraphNet *node, NSUInteger netIdx, BOOL *stop) = ^(DPGraphNet *net, NSUInteger netIdx, BOOL *stop)
    {
        [meshNetsPaths enumerateObjectsUsingBlock:^(NSArray *meshNets, NSUInteger meshIdx, BOOL *stop)
        {
            meshMatrix[meshIdx * currentMatrixCols + netIdx] = [meshNets indexOfObject:net] != NSNotFound ? ([meshNodesPaths[meshIdx][[meshNets indexOfObject:net]] isEqual:net.nodes.firstObject] ? 1 : -1) : 0;
        }];
    };
    
    meshMatrix = self.meshMatrixTree;
    currentMatrixCols = n - 1;
    [self.minimalSpanningTree enumerateObjectsUsingBlock:pathEnumerator];
    
    meshMatrix = self.meshMatrixAntitree;
    currentMatrixCols = m - n + 1;
    [self.antiTree enumerateObjectsUsingBlock:pathEnumerator];
    
    [self writeMatrix:self.incidenceMatrixTree
                 rows:n - 1
                 cols:n - 1
           toFileName:[[self.workingDirectoryURL.relativePath stringByAppendingPathComponent:@"ax"] cStringUsingEncoding:NSASCIIStringEncoding]];
    [self writeMatrix:self.incidenceMatrixAntitree
                 rows:n - 1
                 cols:m - n + 1
           toFileName:[[self.workingDirectoryURL.relativePath stringByAppendingPathComponent:@"ay"] cStringUsingEncoding:NSASCIIStringEncoding]];
    [self writeMatrix:self.meshMatrixTree
                 rows:m - n + 1
                 cols:n - 1
           toFileName:[[self.workingDirectoryURL.relativePath stringByAppendingPathComponent:@"sx"] cStringUsingEncoding:NSASCIIStringEncoding]];
    [self writeMatrix:self.meshMatrixAntitree
                 rows:m - n + 1
                 cols:m - n + 1
           toFileName:[[self.workingDirectoryURL.relativePath stringByAppendingPathComponent:@"sy"] cStringUsingEncoding:NSASCIIStringEncoding]];
    
    free(self.incidenceMatrixTree);
    free(self.meshMatrixTree);
    free(self.incidenceMatrixAntitree);
    free(self.meshMatrixAntitree);
    
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
    LOG(@"\nRunning prim's alghorithm to get minimum spanning tree...\n");
    
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
    
    LOG(@"Minimal spanning tree:\n%@", self.minimalSpanningTree);
    
    LOG(@"\nMinimum spanning tree found successfully...\n");
}

- (BOOL)continuePathToNode:(DPGraphNode*)endNode withMeshNodes:(NSMutableArray*)meshNodes meshNets:(NSMutableArray*)meshNets
{
    if ([meshNodes.lastObject isEqual:endNode])
    {
        return YES;
    }
    
    __block BOOL retVal = NO;
    
    [((DPGraphNode*)meshNodes.lastObject).nets enumerateObjectsUsingBlock:^(DPGraphNet *connectedNet, NSUInteger idx, BOOL *stop)
    {
        if ([self.minimalSpanningTree indexOfObject:connectedNet] != NSNotFound && [meshNets indexOfObject:connectedNet] == NSNotFound)
        {
            [meshNets addObject:connectedNet];
            [meshNodes addObject:[connectedNet.nodes.firstObject isEqual:meshNodes.lastObject] ? connectedNet.nodes.lastObject : connectedNet.nodes.firstObject];
            
            *stop = (retVal = [self continuePathToNode:endNode withMeshNodes:meshNodes meshNets:meshNets]);

            if (!retVal)
            {
                [meshNets removeLastObject];
                [meshNodes removeLastObject];
            }
        }
    }];
    
    return retVal;
}

- (void)writeMatrix:(CGFloat*)matrix rows:(NSUInteger)rows cols:(NSUInteger)cols toFileName:(const char*)name
{
    FILE *f = fopen(name, "wt");
    if (f)
    {
        for(int i = 0; i < rows; i++)
        {
            for(int j = 0; j < cols; j++)
            {
                fprintf(f, "%s ", [[@(matrix[i * cols + j]) stringValue] cStringUsingEncoding:NSASCIIStringEncoding]);
            }
            fprintf(f, "\n");
        }
        fclose(f);
    }
}

@end
