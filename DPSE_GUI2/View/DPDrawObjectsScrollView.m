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
    CGPoint startPoint;
    CGPoint currentPoint;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeight;

@property (nonatomic, strong) UIView *netCanvasView;

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
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomEnabled ? self.contentView : nil;
}

#pragma mark - touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.touchDelegate scrollView:self shouldBeginTouches:event.allTouches withEvent:event])
    {
        [super touchesBegan:touches withEvent:event];
    }
    else
    {
        startPoint = [(UITouch*)touches.anyObject locationInView:self];
        self.netCanvasView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.netCanvasView.backgroundColor = [UIColor redColor];
        self.netCanvasView.layer.cornerRadius   = 5.0f;
        self.netCanvasView.layer.masksToBounds  = YES;
        [self.netCanvasView setCenter:startPoint];
        [self addSubview:self.netCanvasView];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.touchDelegate scrollView:self shouldMoveTouches:event.allTouches withEvent:event])
    {
        [super touchesMoved:touches withEvent:event];
    }
    else
    {
        currentPoint = [(UITouch*)touches.anyObject locationInView:self];
        [self updateNetCanvas];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.touchDelegate scrollView:self shouldEndTouches:event.allTouches withEvent:event])
    {
        [super touchesEnded:touches withEvent:event];
    }
    else
    {
        [self setNeedsDisplay];
        [self.netCanvasView removeFromSuperview];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.contentTapRecognizer)
    {
        return [self.touchDelegate scrollView:self shouldAllowRecognitionForContentRecognizer:gestureRecognizer];
    }
    else
    {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
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


- (void)updateNetCanvas
{
    CGPoint center = CGPointMake((startPoint.x + currentPoint.x) / 2, (startPoint.y + currentPoint.y) / 2);
    [self.netCanvasView setCenter:center];

    CGFloat length = sqrtf((startPoint.x - currentPoint.x) * (startPoint.x - currentPoint.x) + (startPoint.y - currentPoint.y) * (startPoint.y - currentPoint.y));
    [self.netCanvasView setBounds:CGRectMake(0, 0, 10, length)];
    
    CGFloat cos = ((currentPoint.x - startPoint.x) / length);
    CGFloat sin = ((currentPoint.y - startPoint.y) / length);
    [self.netCanvasView setTransform:CGAffineTransformMake/*(cos, sin, -sin, cos, 0, 0)*/(sin, -cos, cos, sin, 0, 0)];
}

@end
