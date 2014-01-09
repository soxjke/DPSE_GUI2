//
//  DPSimulationViewController.m
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

#import "DPSimulationViewController.h"

#import "DPConcentratedParametersSimulationOperation.h"
#import "DPGraphicCanvasView.h"

@interface DPSimulationViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSUInteger _netsCount;
}

@property (nonatomic, weak) IBOutlet UITextView *logTextView;
@property (nonatomic, weak) IBOutlet UITableView *netsTableView;
@property (nonatomic, weak) IBOutlet DPGraphicCanvasView *canvasView;

@property (nonatomic, strong) NSArray *netNames;
@property (nonatomic, strong) NSMutableSet *selectedNetNames;

@end

@implementation DPSimulationViewController
{
    CGFloat minTime;
    CGFloat maxTime;
    CGFloat timeStep;
}

- (void)viewDidLoad
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(toggle:)];
    
    [super viewDidLoad];
    
    DPConcentratedParametersSimulationOperation *op =
    [[DPConcentratedParametersSimulationOperation alloc] initWithGraph:self.graph
                                                              logBlock:^(DPConcentratedParametersSimulationOperation *operation, NSString *logMessage)
    {
        self.logTextView.text = [self.logTextView.text stringByAppendingString:logMessage];
    }
                                                       completionBlock:^(DPConcentratedParametersSimulationOperation *operation, NSString *resultFilePath)
    {
        @autoreleasepool
        {
            self.logTextView.text = [self.logTextView.text stringByAppendingString:@"Simulation finished succsesfully!"];
            self.netNames = [NSArray arrayWithContentsOfFile:[resultFilePath stringByAppendingPathComponent:@"netNames"]];
            self.selectedNetNames = [NSMutableSet setWithArray:self.netNames];

            NSScanner *timeScanner = [NSScanner scannerWithString:[NSString stringWithContentsOfFile:[resultFilePath stringByAppendingPathComponent:@"time"] encoding:NSASCIIStringEncoding error:nil]];
            
            [timeScanner scanFloat:&minTime];
            [timeScanner scanFloat:&maxTime];
            [timeScanner scanFloat:&timeStep];
            
            self.canvasView.minTime = minTime;
            self.canvasView.maxTime = maxTime;
            self.canvasView.timeStep = timeStep;
            
            NSUInteger count = ceil(maxTime - minTime) / timeStep + 1;
            
            NSScanner *globalScanner = [NSScanner scannerWithString:[NSString stringWithContentsOfFile:[resultFilePath stringByAppendingPathComponent:@"q_hor"] encoding:NSASCIIStringEncoding error:nil]];
            
            for (int i = 0; i < self.netNames.count; i++)
            {
                CGFloat *simulationVector = malloc(count * sizeof(CGFloat));
                for (int j = 0; j < count; j++)
                {
                    [globalScanner scanFloat:simulationVector + j];
                }
                [self.canvasView.simulationVectors addPointer:simulationVector];
            }
            
            self.canvasView.vectorNames = [self.netNames mutableCopy];
            
            [self.netsTableView reloadData];
            [self.canvasView setNeedsDisplay];
            
        }
    }];
    
    op.simulation = self.simulation;
    
    [APP_DELEGATE.operationQueue addOperation:op];
    
}

- (void)dealloc
{
    for (int i = 0; i < self.canvasView.simulationVectors.count; i++)
    {
        CGFloat *simulationVector = [self.canvasView.simulationVectors pointerAtIndex:i];
        free(simulationVector);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.netNames.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.accessoryType = [self.selectedNetNames containsObject:self.netNames[indexPath.row]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.textLabel.text = self.netNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *name = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if ([self.selectedNetNames containsObject:name])
    {
        [self.selectedNetNames removeObject:name];
    }
    else
    {
        [self.selectedNetNames addObject:name];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });
}

- (void)toggle:(id)sender
{
    self.logTextView.hidden = !self.logTextView.hidden;
}

@end
