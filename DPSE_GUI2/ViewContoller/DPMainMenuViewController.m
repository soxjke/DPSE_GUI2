//
//  DPMainMenuViewController.m
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

#import "DPMainMenuViewController.h"

#import "DPAboutViewController.h"
#import "DPLoadSplitViewController.h"
#import "DPSettingsSplitViewController.h"
#import "DPEditViewController.h"

@interface DPMainMenuViewController ()
{
    DPAboutViewController *_aboutBox;
}

- (IBAction)unwindToMainMenu:(UIStoryboardSegue*)segue;

@end

@implementation DPMainMenuViewController

#pragma mark - segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]])
    {
        UIPopoverController *popover = ((UIStoryboardPopoverSegue*)segue).popoverController;
        
        CGSize popoverSize = CGSizeMake(700, 700);
        
        [popover setPopoverContentSize:popoverSize];
        
        _aboutBox = segue.destinationViewController;
        
        return;
    }
    if ([[(UINavigationController*)segue.destinationViewController topViewController] isKindOfClass:[UISplitViewController class]])
    {
        UISplitViewController *splitViewController = (UISplitViewController*)[(UINavigationController*)segue.destinationViewController topViewController];
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        return;
    }
    if ([[(UINavigationController*)segue.destinationViewController topViewController] isKindOfClass:[DPEditViewController class]])
    {
        DPEditViewController *editViewController = (DPEditViewController*)[(UINavigationController*)segue.destinationViewController topViewController];
        editViewController.isConcentratedParameters = [IS_CONCENTRATED_PARAMETERS boolValue];
    }
}

#pragma mark - unwind segues

- (IBAction)unwindToMainMenu:(UIStoryboardSegue*)segue
{
    _aboutBox = nil;
}

#pragma mark - popover management

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (_aboutBox)
    {
        [_aboutBox performSegueWithIdentifier:@"unwindToMainMenu" sender:self];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [self performSegueWithIdentifier:@"showAboutDialogBox" sender:self.view];
        });
    }
}

@end
