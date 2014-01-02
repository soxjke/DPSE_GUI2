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

- (IBAction)toolboxButtonPressed:(UIButton *)sender;

@end

@implementation DPEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(dbg:)];
    
    self.selectButton.tag       = DPTouchModeCursor;
    self.nodeButton.tag         = DPTouchModeNode;
    self.netButton.tag          = DPTouchModeNet;
    
    self.selectButton.selected  = YES;
    
    self.toolboxButtons         = @[self.selectButton, self.nodeButton, self.netButton];
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
    
}

#pragma mark - DPDrawObjectsScrollViewDelegate

- (BOOL)scrollView:(DPDrawObjectsScrollView *)scrollView shouldBeginTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    return (currentTouchMode != DPTouchModeNet);
}

- (BOOL)scrollView:(DPDrawObjectsScrollView *)scrollView shouldMoveTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    return (currentTouchMode != DPTouchModeNet);
}

- (BOOL)scrollView:(DPDrawObjectsScrollView *)scrollView shouldEndTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    return (currentTouchMode != DPTouchModeNet);
}

- (void)dbg:(id)sender
{
    
}

@end
