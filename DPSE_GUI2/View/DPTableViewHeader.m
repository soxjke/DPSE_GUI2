//
//  DPTableViewHeader.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/7/14.

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

#import "DPTableViewHeader.h"

@interface DPTableViewHeader ()
{
    UILabel *_label;
}

@end

@implementation DPTableViewHeader

+ (CGFloat)height
{
    return 25.0f;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _label = [UILabel new];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor purpleColor];
        _label.font = [UIFont systemFontOfSize:20.0f];
        _label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)prepareForReuse
{
    self.text = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setText:(NSString *)text
{
    _label.text = text;
}

- (NSString*)text
{
    return _label.text;
}

@end
