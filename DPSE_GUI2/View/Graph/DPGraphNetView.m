//
//  DPGraphNetView.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/5/14.

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

#import "DPGraphNetView.h"

@interface DPGraphNetView ()
{
    CGPoint _startPoint;
    CGPoint _endPoint;
    CGFloat _netWidth;
}

@end

@implementation DPGraphNetView

+ (instancetype)netViewFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    return [[self alloc] initFromPoint:startPoint toPoint:endPoint];
}

- (instancetype)initFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self = [super init];
    if (self)
    {
        _startPoint = startPoint;
        _endPoint   = endPoint;
        
        _netWidth = [NET_WIDTH floatValue];
        
        self.backgroundColor        = NET_COLOR;
        self.layer.cornerRadius     = _netWidth / 2;
        self.layer.masksToBounds    = YES;
        
        [self calculate];
    }
    return self;
}

#pragma mark - maths

- (void)calculate
{
    CGPoint center = CGPointMake((_startPoint.x + _endPoint.x) / 2, (_startPoint.y + _endPoint.y) / 2);
    [self setCenter:center];
    
    CGFloat length = sqrtf((_startPoint.x - _endPoint.x) * (_startPoint.x - _endPoint.x) + (_startPoint.y - _endPoint.y) * (_startPoint.y - _endPoint.y));
    [self setBounds:CGRectMake(0, 0, _netWidth, length)];
    
    CGFloat cos = ((_endPoint.x - _startPoint.x) / length);
    CGFloat sin = ((_endPoint.y - _startPoint.y) / length);
    [self setTransform:CGAffineTransformMake(sin, -cos, cos, sin, 0, 0)];
}

#pragma mark - getter/setter

- (void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;
    [self calculate];
}

- (void)setEndPoint:(CGPoint)endPoint
{
    _endPoint = endPoint;
    [self calculate];
}

- (CGPoint)startPoint
{
    return _startPoint;
}

- (CGPoint)endPoint
{
    return _endPoint;
}

@end
