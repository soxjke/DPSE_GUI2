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
    
    UILabel *xCaption;
    UILabel *yCaption;
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
    
    xCaption = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    yCaption = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    [self addSubview:xCaption];
    [self addSubview:yCaption];
    
    UIGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGR];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self recalculate];
}

- (void)recalculate
{
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    
    xScale = CGRectGetWidth(self.bounds)  / (self.maxTime - self.minTime);
    yScale = CGRectGetHeight(self.bounds) / (maxValue - minValue);
    
    xCaption.text = [@(self.maxTime) stringValue];
    xCaption.center = CGPointMake(selfWidth - 30.0f, selfHeight + minValue * yScale - 16.0f);

    yCaption.text = [@(maxValue) stringValue];
    yCaption.center = CGPointMake(- self.minTime * xScale + 31.0f, 16.0f);
}

- (void)drawRect:(CGRect)rect
{
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    
    // draw axes
    // x
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, 0, selfHeight + minValue * yScale - 1.0f);
    CGContextAddLineToPoint(context, selfWidth, selfHeight + minValue * yScale - 1.0f);
    CGContextStrokePath(context);
    // y
    CGContextMoveToPoint(context, - self.minTime * xScale + 1.0f, 0);
    CGContextAddLineToPoint(context, - self.minTime * xScale + 1.0f, selfHeight);
    CGContextStrokePath(context);
    
    for (int i = 0; i < self.simulationVectors.count; i++)
    {
        // draw functions
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

- (void)tap:(UITapGestureRecognizer*)recognizer
{
    [self setNeedsDisplay];
}

@end
