//
//  DPGridView.m
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

#import "DPGridView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DPGridView
{
    NSMutableArray *colors;
}

- (void)awakeFromNib
{
    self.baseColor = [UIColor blueColor];
    self.gridSteps = @[@128.0f, @32.0f];
    
    [self update];
}

- (void)update
{
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop)
    {
        [subview removeFromSuperview];
    }];
    
    NSUInteger length = self.gridSteps.count;

    [self buildColorsArrayOfLength:length];
    
    [self createGridWithSteps:self.gridSteps bounds:self.bounds colors:colors isHorizontal:NO];
    [self createGridWithSteps:self.gridSteps bounds:self.bounds colors:colors isHorizontal:YES];
}

- (void)createGridWithSteps:(NSArray*)steps bounds:(CGRect)bounds colors:(NSArray*)aColors isHorizontal:(BOOL)isHorizontal
{
    if (!steps.count) return;
    
    CGFloat left    = CGRectGetMinX(bounds);
    CGFloat top     = CGRectGetMinY(bounds);
    
    CGFloat height  = CGRectGetHeight(bounds);
    CGFloat width   = CGRectGetWidth(bounds);
    
    CGFloat centerX = CGRectGetMidX(bounds);
    CGFloat centerY = CGRectGetMidY(bounds);
    
    CGFloat step = [steps.firstObject floatValue];
    
    NSUInteger numberOfSteps = (isHorizontal ? height : width) / step + 1;
    
    step = (isHorizontal ? height : width) / numberOfSteps;
    
    for (NSUInteger index = 0; index < numberOfSteps; index++)
    {
        UIView *view            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, isHorizontal ? width : steps.count, isHorizontal ? steps.count : height)];
        view.center             = CGPointMake(isHorizontal ? centerX : left + step * index, isHorizontal ? top + step * index : centerY);
        view.backgroundColor    = aColors.firstObject;
        
        [self addSubview:view];
        [self createGridWithSteps:[steps subarrayWithRange:NSMakeRange(1, steps.count - 1)]
                           bounds:CGRectMake(isHorizontal ? 0 : left + step * index, isHorizontal ? top + step * index: 0, isHorizontal ? width : step, isHorizontal ? step : height)
                           colors:[aColors subarrayWithRange:NSMakeRange(1, aColors.count - 1)]
                     isHorizontal:isHorizontal];
    }
    
    UIView *view            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, isHorizontal ? width : steps.count, isHorizontal ? steps.count : height)];
    view.center             = CGPointMake(isHorizontal ? centerX : top + height, isHorizontal ? left + width : centerY);
    view.backgroundColor    = aColors.firstObject;
}

- (void)buildColorsArrayOfLength:(NSUInteger)length
{
    colors = [NSMutableArray new];
    @try
    {
        const CGFloat *redGreenBlue = CGColorGetComponents(self.baseColor.CGColor);
        
        for (NSUInteger indx = length; indx; indx--)
        {
            [colors addObject:[UIColor colorWithRed:redGreenBlue[0] * (CGFloat)indx / length
                                              green:redGreenBlue[1] * (CGFloat)indx / length
                                               blue:redGreenBlue[2] * (CGFloat)indx / length
                                              alpha:1]];
        }
    }
    @catch (NSException *exception) {}
    @finally {}
}

@end