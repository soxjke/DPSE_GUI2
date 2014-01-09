//
//  DPGraphicCanvasView.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/9/14.

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

#import "DPGraphicCanvasView.h"

@implementation DPGraphicCanvasView
{
    CGFloat minValue;
    CGFloat maxValue;
    
    CGFloat xScale;
    CGFloat yScale;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.simulationVectors = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory | NSPointerFunctionsIntegerPersonality];
    maxValue = 100.0f;
    minValue = -10.0f;
    self.maxTime = 1.0f;
    self.minTime = 0.0f;
    self.timeStep = 0.01f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self recalculate];
}

- (void)recalculate
{
    xScale = CGRectGetWidth(self.bounds)  / (self.maxTime - self.minTime);
    yScale = CGRectGetHeight(self.bounds) / (maxValue - minValue);
}

- (void)drawRect:(CGRect)rect
{
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    for (int i = 0; i < self.simulationVectors.count; i++)
    {
        int j = 0;
        CGFloat curTime = self.minTime;
        CGFloat *simulationVector = [self.simulationVectors pointerAtIndex:i];
        UIColor *curGraphColor = [UIColor colorWithRed:(float)i / (float)self.simulationVectors.count green:0.0f blue:1.0f - (float)i / (float)self.simulationVectors.count alpha:1.0f];
        CGContextSetStrokeColorWithColor(context, curGraphColor.CGColor);
        CGContextMoveToPoint(context, (curTime - self.minTime) * xScale, selfHeight - (simulationVector[j] - minValue) * yScale);
        do
        {
            curTime += self.timeStep;
            CGContextAddLineToPoint(context, (curTime - self.minTime) * xScale, selfHeight - (simulationVector[++j] - minValue) * yScale);
        }
        while (curTime < self.maxTime);

        CGContextStrokePath(context);
    }
}

- (void)setNeedsDisplay
{
    [self recalculate];
    [super setNeedsDisplay];
}

@end
