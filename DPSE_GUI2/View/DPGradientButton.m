//
//  DPGradientButton.m
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

#import "DPGradientButton.h"

#import <QuartzCore/QuartzCore.h>

@interface DPGradientButton ()
{
    CAGradientLayer *_gradientLayer;
}

@end

@implementation DPGradientButton

@synthesize topColor    = _topColor;
@synthesize bottomColor = _bottomColor;
@synthesize startPoint  = _startPoint;
@synthesize endPoint    = _endPoint;

#pragma mark - init / frame management

- (void)awakeFromNib
{
    // Init defaults
    
    _topColor       = [UIColor buttonTopGradientColor];
    _bottomColor    = [UIColor buttonBottomGradientColor];
    _startPoint     = CGPointMake(0.5f, 0.0f);
    _endPoint       = CGPointMake(0.5f, 1.0f);
    
    // Init gradient layer
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;

    _gradientLayer.colors       = @[(id)_topColor.CGColor, (id)_bottomColor.CGColor];
    _gradientLayer.startPoint   = _startPoint;
    _gradientLayer.endPoint     = _endPoint;

    [self.layer insertSublayer:_gradientLayer atIndex:0];
    
    self.layer.cornerRadius     = 15.0f;
    self.layer.masksToBounds    = YES;
    
    self.layer.borderColor      = [UIColor blackColor].CGColor;
    self.layer.borderWidth      = 2.0f;
}

- (void)setFrame:(CGRect)frame
{
    [super          setFrame:frame];
    [_gradientLayer setFrame:self.bounds];
}

#pragma mark - setter / getter

- (void)setTopColor:(UIColor *)topColor
{
    _topColor               = topColor;
    _gradientLayer.colors   = @[(id)topColor.CGColor, (id)_bottomColor.CGColor];
}

- (void)setBottomColor:(UIColor *)bottomColor
{
    _bottomColor            = bottomColor;
    _gradientLayer.colors   = @[(id)_topColor.CGColor, (id)bottomColor.CGColor];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    _startPoint                 = startPoint;
    _gradientLayer.startPoint   = startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint
{
    _endPoint                   = endPoint;
    _gradientLayer.endPoint     = endPoint;
}

- (UIColor*)topColor
{
    return _topColor;
}

- (UIColor*)bottomColor
{
    return _bottomColor;
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
