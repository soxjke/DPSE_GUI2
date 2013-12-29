//
//  DPBlockAlertView.m
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

#import "DPBlockAlertView.h"

NSMutableArray *alerts;

@interface DPBlockAlertView () <UIAlertViewDelegate>

@end

@implementation DPBlockAlertView
{
    DPAlertCompletionBlock _completion;
}

+ (void)load
{
    alerts = [NSMutableArray new];
}

+ (void)alertWithCompletion:(DPAlertCompletionBlock)completion
                      title:(NSString *)title
                    message:(NSString *)message
          cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
{
    DPBlockAlertView *alert = [[DPBlockAlertView alloc] initWithCompletion:completion title:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alert show];
}

- (instancetype)initWithCompletion:(DPAlertCompletionBlock)completion
                             title:(NSString *)title
                           message:(NSString *)message
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    if (self)
    {
        self.delegate = self;
        _completion = completion;
    }
    
    [alerts addObject:self];
    
    return self;
}

- (void)alertView:(DPBlockAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _completion(alertView, buttonIndex);
    [alerts removeObject:alertView];
}

@end
