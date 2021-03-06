//
//  DPEditViewController.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 12/29/13.

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

#import "DPEditViewController.h"
#import "DPDrawObjectsScrollView.h"
#import "DPTransparentContainerView.h"

#import "DPPropertiesPanelElement.h"
#import "DPPropertiesPanelViewController.h"
#import "DPSimulationViewController.h"

#import "DPGraph.h"
#import "DPGraphNet.h"
#import "DPGraphNode.h"

#import "DPGraphNode+DPPropertiesPanelElement.h"
#import "DPGraphNet+DPPropertiesPanelElement.h"

#import "Graph.h"
#import "Simulation.h"

typedef NS_ENUM(NSUInteger, DPTouchMode)
{
    DPTouchModeCursor,
    DPTouchModeNode,
    DPTouchModeNet
};

@interface DPEditViewController () <DPDrawObjectsScrollViewDelegate>
{
    DPTouchMode currentTouchMode;
}


@property (weak, nonatomic) IBOutlet DPDrawObjectsScrollView *scrollView;

@property (weak, nonatomic) IBOutlet DPTransparentContainerView *toolboxView;
@property (weak, nonatomic) IBOutlet UIButton *netButton;
@property (weak, nonatomic) IBOutlet UIButton *nodeButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (strong, nonatomic) NSArray *toolboxButtons;

@property (strong, nonatomic) NSLayoutConstraint *propertiesPanelTopOffset;
@property (strong, nonatomic) NSLayoutConstraint *propertiesPanelBottomOffset;
@property (strong, nonatomic) NSLayoutConstraint *propertiesPanelTrailingOffset;
@property (strong, nonatomic) NSLayoutConstraint *propertiesPanelWidth;

@property (weak, nonatomic) DPPropertiesPanelViewController *propertiesPanel;

- (IBAction)toolboxButtonPressed:(UIButton *)sender;

@end

@implementation DPEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
    
    self.selectButton.tag       = DPTouchModeCursor;
    self.nodeButton.tag         = DPTouchModeNode;
    self.netButton.tag          = DPTouchModeNet;
    
    self.selectButton.selected  = YES;
    
    self.toolboxButtons         = @[self.selectButton, self.nodeButton, self.netButton];
    
    if (!self.graph)                self.graph = [DPGraph new];
    if (!self.graphCoreDataObject)  self.graphCoreDataObject = [[Graph alloc] initWithEntity:APP_DELEGATE.graphEntity
                                                              insertIntoManagedObjectContext:APP_DELEGATE.managedObjectContext];
    [APP_DELEGATE saveContext];
}

#pragma mark - actions

- (void)backButtonPressed:(id)sender
{
    [DPBlockAlertView alertWithCompletion:^(DPBlockAlertView *alertView, NSUInteger selectedOption)
    {
        if (selectedOption == 1) // User tapped "Save"
        {
            [self save];
        }
        
        if (selectedOption != 0)    // User didn't tap cancel
        {
            [self performSegueWithIdentifier:@"unwindToMainMenu" sender:self];
        }
    }
                                    title:@"Close model"
                                  message:@"Are you sure you want to close this model? All changes will be lost."
                        cancelButtonTitle:@"Cancel"
                        otherButtonTitles:@"Save", @"Don't save", nil];
}

- (IBAction)toolboxButtonPressed:(UIButton *)sender
{
    [self.toolboxButtons[currentTouchMode] setSelected:NO];
    
    currentTouchMode                = sender.tag;
    
    self.scrollView.scrollEnabled   = (currentTouchMode == DPTouchModeCursor);
    self.scrollView.zoomEnabled     = (currentTouchMode == DPTouchModeCursor);
    
    [sender setSelected:YES];
}

#pragma mark - business logic

- (void)save
{
    
}

#pragma mark - segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSimultationResults"])
    {
        Simulation *simulationObject = [[Simulation alloc] initWithEntity:APP_DELEGATE.simulationEntity insertIntoManagedObjectContext:APP_DELEGATE.managedObjectContext];
        
        [self.graphCoreDataObject addSimulationsObject:simulationObject];
        [APP_DELEGATE saveContext];
        
        ((DPSimulationViewController*)segue.destinationViewController).simulation = simulationObject;
        ((DPSimulationViewController*)segue.destinationViewController).graph = self.graph;
    }
}

#pragma mark - DPDrawObjectsScrollViewDelegate

- (BOOL)scrollView:(DPDrawObjectsScrollView *)scrollView shouldBeginTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    return (currentTouchMode != DPTouchModeNet || touches.count != 1);
}

- (BOOL)scrollView:(DPDrawObjectsScrollView *)scrollView shouldMoveTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    return (currentTouchMode != DPTouchModeNet || touches.count != 1);
}

- (BOOL)scrollView:(DPDrawObjectsScrollView *)scrollView shouldEndTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    return (currentTouchMode != DPTouchModeNet || touches.count != 1);
}

- (BOOL)scrollView:(DPDrawObjectsScrollView *)scrollView shouldAllowRecognitionForContentRecognizer:(UIGestureRecognizer *)recognizer
{
    return currentTouchMode == DPTouchModeNode && recognizer == scrollView.contentTapRecognizer;
}

- (void)scrollView:(DPDrawObjectsScrollView *)scrollView didDrawNet:(DPGraphNet *)net
{
    [self.graph addNet:net];
}

- (void)scrollView:(DPDrawObjectsScrollView *)scrollView didDrawNode:(DPGraphNode *)node
{
    [self.graph addNode:node];
}

- (void)scrollView:(DPDrawObjectsScrollView*)scrollView didSelectNode:(DPGraphNode*)node
{
    if (!self.propertiesPanel) [self showPropertiesForItem:node];
    else self.propertiesPanel.propertiesPanelElement = node;
}

- (void)scrollView:(DPDrawObjectsScrollView*)scrollView didSelectNet:(DPGraphNet*)net
{
    if (!self.propertiesPanel) [self showPropertiesForItem:net];
    else self.propertiesPanel.propertiesPanelElement = net;
}

- (void)action:(id)sender
{
    [DPBlockActionSheet actionSheetWithCompletion:^(DPBlockActionSheet *actionSheet, NSUInteger selectedOption)
    {
        NSLog(@"Selected title %@ at index %d", [actionSheet buttonTitleAtIndex:selectedOption], selectedOption);
        if (selectedOption == 4)
        {
            [self performSegueWithIdentifier:@"showSimultationResults" sender:self];            
        }
    }
                                            title:nil
                                cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:@"Delete"
                                otherButtonTitles:@"Save", @"Save as", @"Run simulation", nil
     ];
    
/*    if (!self.propertiesPanel)
    {
        [self showPropertiesForItem:nil];
    }
    else
    {
        [self hideProperties];
    }
*/
}

#pragma mark - child view controller

- (void)showPropertiesForItem:(id <DPPropertiesPanelElement>)item;
{
    if (!self.propertiesPanel)
    {
        self.propertiesPanel = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DPPropertiesPanelViewController class])];
    }
    
    [self addChildViewController:self.propertiesPanel];
    [self.view addSubview:self.propertiesPanel.view];
    
    [self.propertiesPanel.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.propertiesPanelTopOffset = [NSLayoutConstraint constraintWithItem:self.propertiesPanel.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:64.0f];
    self.propertiesPanelBottomOffset = [NSLayoutConstraint constraintWithItem:self.propertiesPanel.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10.0f];
    self.propertiesPanelTrailingOffset = [NSLayoutConstraint constraintWithItem:self.propertiesPanel.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    self.propertiesPanelWidth = [NSLayoutConstraint constraintWithItem:self.propertiesPanel.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:320.0f];
    
    [self.view addConstraints:@[self.propertiesPanelBottomOffset, self.propertiesPanelTopOffset, self.propertiesPanelTrailingOffset]];
    [self.propertiesPanel.view addConstraint:self.propertiesPanelWidth];
    
    self.propertiesPanel.propertiesPanelElement = item;
    
    [UIView animateWithDuration:0.4f
                     animations:^(void)
    {
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished)
    {
        [self.propertiesPanel didMoveToParentViewController:self];
    }];
}

- (void)hideProperties
{
    [self.propertiesPanel willMoveToParentViewController:nil];
    
    self.propertiesPanelTrailingOffset.constant = self.propertiesPanelWidth.constant;
    
    [UIView animateWithDuration:0.4f
                     animations:^(void)
    {
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished)
    {
        [self.propertiesPanel.view removeFromSuperview];
        [self.view removeConstraints:@[self.propertiesPanelTopOffset, self.propertiesPanelTopOffset, self.propertiesPanelTrailingOffset]];
        [self.propertiesPanel removeFromParentViewController];
    }];
}

@end
