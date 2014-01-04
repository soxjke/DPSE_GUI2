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
#import <QuartzCore/QuartzCore.h>

@interface DPDrawObjectsScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    BOOL isDrawingLine;
    CGPoint startPoint;
    CGPoint currentPoint;
}

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
    self.netDrawColor = [UIColor redColor];
    
    self.contentTapRecognizer           = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.contentTapRecognizer.delegate  = self;
    [self.contentView addGestureRecognizer:self.contentTapRecognizer];
    
    isDrawingLine = NO;
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomEnabled ? self.contentView : nil;
}

#pragma mark - touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.touchDelegate scrollView:self shouldBeginTouches:touches withEvent:event])
    {
        [super touchesBegan:touches withEvent:event];
    }
    else
    {
        isDrawingLine = YES;
        startPoint = [(UITouch*)touches.anyObject locationInView:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.touchDelegate scrollView:self shouldMoveTouches:touches withEvent:event])
    {
        [super touchesMoved:touches withEvent:event];
    }
    else
    {
        currentPoint = [(UITouch*)touches.anyObject locationInView:self];
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.touchDelegate scrollView:self shouldEndTouches:touches withEvent:event])
    {
        [super touchesEnded:touches withEvent:event];
    }
    else
    {
        isDrawingLine = NO;
        [self setNeedsDisplay];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return [self.touchDelegate scrollView:self shouldAllowRecognitionForContentRecognizer:gestureRecognizer];
}

- (void)tap:(UITapGestureRecognizer*)recognizer
{
    CGPoint touchLocation = [recognizer locationInView:self.contentView];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [view setCenter:touchLocation];
    view.backgroundColor = [UIColor greenColor];
    view.layer.cornerRadius = 10.0f;
    view.layer.masksToBounds = YES;
    
    [self.contentView addSubview:view];
}

#pragma mark - hack

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return (aSelector == @selector(drawRect:)) ? isDrawingLine : [super respondsToSelector:aSelector];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (isDrawingLine)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.netDrawColor.CGColor);
        CGContextSetLineWidth(context, 5.0f);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        CGContextStrokePath(context);
    }
}

@end
