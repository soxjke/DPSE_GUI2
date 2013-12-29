//
//  DPLoadMasterViewController.m
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

#import "DPLoadDetailViewController.h"

#import "Graph.h"

@interface DPLoadDetailViewController ()

- (void)configureView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonsContainerTopAnchor;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonsContainerLeftAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsContainerHeightAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadButtonWidthAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButtonWidthAnchor;

@property (nonatomic, weak) IBOutlet UIImageView    * previewImageView;
@property (nonatomic, strong) IBOutlet UIView         * buttonsPreviewView;
@property (nonatomic, weak) IBOutlet UITableView    * infoTableView;

@end

@implementation DPLoadDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (![_detailItem isEqual:newDetailItem])
    {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem)
    {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewWillLayoutSubviews
{
    UIInterfaceOrientation toInterfaceOrientation = self.interfaceOrientation;
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        //        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsContainerLeftAnchor.firstItem
        //                                                                         attribute:self.buttonsContainerLeftAnchor.firstAttribute
        //                                                                         relatedBy:self.buttonsContainerLeftAnchor.relation
        //                                                                            toItem:self.previewImageView
        //                                                                         attribute:self.buttonsContainerLeftAnchor.secondAttribute
        //                                                                        multiplier:self.buttonsContainerLeftAnchor.multiplier
        //                                                                          constant:self.buttonsContainerLeftAnchor.constant];
        //        [self.buttonsPreviewView removeConstraint:self.buttonsContainerLeftAnchor];
        //        [self.buttonsPreviewView addConstraint:newConstraint];
        //        self.buttonsContainerLeftAnchor = newConstraint;
        //        self.buttonsContainerLeftAnchor.secondItem  = self.previewImageView;
        //        self.buttonsContainerTopAnchor.secondItem   = self.topLayoutGuide;
    }
    else if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        /*
         self.buttonsContainerLeftAnchor.secondItem  = self.view;
         self.buttonsContainerTopAnchor.secondItem   = self.previewImageView;
         */
        
        self.buttonsContainerHeightAnchor.constant  = 70.0f;
        self.loadButtonWidthAnchor.constant         = 160.0f;
        self.deleteButtonWidthAnchor.constant       = 160.0f;
        
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsContainerLeftAnchor.firstItem
                                                                         attribute:self.buttonsContainerLeftAnchor.firstAttribute
                                                                         relatedBy:self.buttonsContainerLeftAnchor.relation
                                                                            toItem:self.view
                                                                         attribute:self.buttonsContainerLeftAnchor.firstAttribute
                                                                        multiplier:self.buttonsContainerLeftAnchor.multiplier
                                                                          constant:self.buttonsContainerLeftAnchor.constant];
        
        [self.view removeConstraint:self.buttonsContainerLeftAnchor];
        
        NSLayoutConstraint *newConstraint2 = [NSLayoutConstraint constraintWithItem:self.buttonsContainerTopAnchor.firstItem
                                                                          attribute:self.buttonsContainerTopAnchor.firstAttribute
                                                                          relatedBy:self.buttonsContainerTopAnchor.relation
                                                                             toItem:self.previewImageView
                                                                          attribute:self.buttonsContainerTopAnchor.secondAttribute
                                                                         multiplier:self.buttonsContainerTopAnchor.multiplier
                                                                           constant:self.buttonsContainerTopAnchor.constant];
        
        [self.view removeConstraint:self.buttonsContainerTopAnchor];
        
        [self.view addConstraint:newConstraint2];
        [self.view addConstraint:newConstraint];
        self.buttonsContainerLeftAnchor = newConstraint;
        
        self.buttonsContainerTopAnchor = newConstraint2;
    }
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

@end
