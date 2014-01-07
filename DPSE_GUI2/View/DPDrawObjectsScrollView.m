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

#import "DPGraphNetView.h"
#import "DPGraphNodeView.h"

@interface DPDrawObjectsScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    CGPoint startPoint;
    CGPoint currentPoint;
    
    DPGraphNodeView *_startNode;
    DPGraphNodeView *_endNode;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeight;

@property (nonatomic, strong) DPGraphNetView *netCanvasView;

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
        _startNode = (DPGraphNodeView*)[self hitTest:startPoint withEvent:event];
        CGFloat netWidth = [NET_WIDTH floatValue];
        currentPoint = CGPointMake(startPoint.x + netWidth, startPoint.y + netWidth);
        self.netCanvasView = [DPGraphNetView netViewFromPoint:startPoint toPoint:currentPoint];
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
        self.netCanvasView.endPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.touchDelegate scrollView:self shouldEndTouches:event.allTouches withEvent:event])
    {
        [super touchesEnded:touches withEvent:event];
        UIView *view = [self.contentView hitTest:[(UITouch*)touches.anyObject locationInView:self.contentView] withEvent:event];
        if ([view isKindOfClass:[DPGraphNetView class]])
        {
            [self.touchDelegate scrollView:self didSelectNet:((DPGraphNetView*)view).net];
        }
        else if ([view isKindOfClass:[DPGraphNodeView class]])
        {
            [self.touchDelegate scrollView:self didSelectNode:((DPGraphNodeView*)view).node];
        }
    }
    else
    {
        _endNode = (DPGraphNodeView*)[self hitTest:currentPoint withEvent:event];
        [self.netCanvasView removeFromSuperview];
        [self tryToAddNetFromPoint:startPoint toPoint:currentPoint];
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

    DPGraphNodeView *nodeView = [DPGraphNodeView nodeAtPoint:touchLocation];
    DPGraphNode     *node     = [DPGraphNode nodeWithLocation:touchLocation];
    
    nodeView.node = node;
    
    [self.contentView addSubview:nodeView];
    
    [self.touchDelegate scrollView:self didDrawNode:node];
}

#pragma mark - DPGraphNodeViewDelegate

- (void)tryToAddNetFromPoint:(CGPoint)point toPoint:(CGPoint)endPoint
{
    if ([_startNode isKindOfClass:[DPGraphNodeView class]] && [_endNode isKindOfClass:[DPGraphNodeView class]])
    {
        DPGraphNetView *netView = [DPGraphNetView netViewFromPoint:_startNode.center toPoint:_endNode.center];
        [self.contentView addSubview:netView];
        [self.contentView sendSubviewToBack:netView];
        
        DPGraphNet *net = [DPGraphNet netFromNode:_startNode.node toNode:_endNode.node];
        netView.net     = net;
        
        [self.touchDelegate scrollView:self didDrawNet:net];
        
    }
    _startNode = nil;
    _endNode   = nil;
}

@end
