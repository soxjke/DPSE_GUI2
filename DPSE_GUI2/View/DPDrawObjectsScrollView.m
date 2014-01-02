//
//  DPDrawObjectsScrollView.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 12/30/13.

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

#import "DPDrawObjectsScrollView.h"

@interface DPDrawObjectsScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeight;

@end

@implementation DPDrawObjectsScrollView

#pragma mark - public

- (void)extendContentHorizontally
{
    
}

- (void)extendContentVertically
{
    
}

#pragma mark - private

- (void)awakeFromNib
{
    self.delegate = self;
    
    self.zoomEnabled = YES;
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomEnabled ? self.contentView : nil;
}

@end
