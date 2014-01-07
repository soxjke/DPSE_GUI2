//
//  UIColor+ApplicationColorScheme.m
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

#import "UIColor+ApplicationColorScheme.h"

#define INT_COMPONENT_TO_FLOAT 255.0f

#define COLOR_FLOAT(r, g, b, a) \
do \
{ \
    static UIColor *color = nil; \
    if (!color) \
    { \
        color = [UIColor colorWithRed:r green:g blue:b alpha:a]; \
    } \
    return color; \
} while (0);

#define COLOR_INT(r, g, b, a) COLOR_FLOAT(  ((CGFloat)r) / INT_COMPONENT_TO_FLOAT, \
                                            ((CGFloat)g) / INT_COMPONENT_TO_FLOAT, \
                                            ((CGFloat)b) / INT_COMPONENT_TO_FLOAT, \
                                            ((CGFloat)a) / INT_COMPONENT_TO_FLOAT);
        

@implementation UIColor (ApplicationColorScheme)

+ (UIColor*)buttonTopGradientColor
{
    COLOR_INT(226, 230, 124, 255);
}

+ (UIColor*)buttonBottomGradientColor
{
    COLOR_INT(112, 115, 22, 255);
}

+ (UIColor*)silverBorderColor
{
    COLOR_INT(192, 192, 192, 255);
}

+ (UIColor*)transparentContainerColor
{
    COLOR_INT(0, 0, 0, 75);
}

+ (UIColor*)nodeInnerColorDefault
{
    COLOR_INT(101, 174, 192, 255);
}

+ (UIColor*)nodeOuterColorDefault
{
    COLOR_INT(38, 38, 38, 255);
}

+ (UIColor*)netColorDefault
{
    COLOR_INT(38, 38, 38, 255);
}

@end
