//
//  NSLayoutConstraint+Setter.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 12/8/13.

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

#import "NSLayoutConstraint+Setter.h"
#import <objc/runtime.h>

@implementation NSLayoutConstraint (Setter)

Ivar firstItemIvar;
Ivar secondItemIvar;

+ (void)load
{
    void                *outValue;
    NSLayoutConstraint  *layoutConstraint = [[self alloc] init];
    firstItemIvar       = object_getInstanceVariable(layoutConstraint, "_firstItem", &outValue);
    secondItemIvar      = object_getInstanceVariable(layoutConstraint, "_secondItem", &outValue);
    [layoutConstraint release];
}

- (void)setFirstItem:(id)firstItem
{
    object_setIvar(self, firstItemIvar, firstItem);
}

- (void)setSecondItem:(id)secondItem
{
    object_setIvar(self, secondItemIvar, secondItem);
}

- (void)setMultiplier:(CGFloat)multiplier
{
    object_setInstanceVariable(self, "_coefficient", &multiplier);
}

@end
