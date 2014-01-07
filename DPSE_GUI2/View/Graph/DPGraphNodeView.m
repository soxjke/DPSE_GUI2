//
//  DPGraphNodeView.m
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

#import "DPGraphNodeView.h"

#import <QuartzCore/QuartzCore.h>

@implementation DPGraphNodeView

+ (instancetype)nodeAtPoint:(CGPoint)center
{
    return [[self alloc] initAtPoint:center];
}

- (instancetype)initAtPoint:(CGPoint)center
{
    self = [super init];
    if (self)
    {
        CGFloat borderWidth         = [NODE_BORDER_WIDTH floatValue];
        CGFloat innerRadius         = [NODE_INNER_RADIUS floatValue];
        
        self.backgroundColor        = NODE_INNER_COLOR;
        
        self.layer.borderColor      = [NODE_OUTER_COLOR CGColor];
        self.layer.borderWidth      = borderWidth;
        
        self.layer.cornerRadius     = (borderWidth + innerRadius) / 2;
        self.layer.masksToBounds    = YES;
        
        self.center                 = center;
        self.bounds                 = CGRectMake(0, 0, borderWidth + innerRadius, borderWidth + innerRadius);
    }
    return self;
}

@end
