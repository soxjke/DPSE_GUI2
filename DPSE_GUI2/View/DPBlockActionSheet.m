//
//  DPBlockActionSheet.m
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

#import "DPBlockActionSheet.h"

NSMutableArray *actionSheets;

@interface DPBlockActionSheet () <UIActionSheetDelegate>

@end

@implementation DPBlockActionSheet
{
    DPActionSheetCompletionBlock _completion;
}

+ (void)load
{
    actionSheets = [NSMutableArray new];
}

+ (void)actionSheetWithCompletion:(DPActionSheetCompletionBlock)completion
                            title:(NSString *)title
                cancelButtonTitle:(NSString *)cancelButtonTitle
           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list otherTitles;
    va_start(otherTitles, otherButtonTitles);
    
    DPBlockActionSheet *actionSheet = [[self alloc] initWithCompletion:completion
                                                                 title:title
                                                     cancelButtonTitle:cancelButtonTitle
                                                destructiveButtonTitle:destructiveButtonTitle
                                                     otherButtonTitles:nil];
    
    for (NSString *otherTitle = otherButtonTitles; otherTitle; otherTitle = va_arg(otherTitles, NSString*))
    {
        [actionSheet addButtonWithTitle:otherTitle];
    }
    
    va_end(otherTitles);
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

- (instancetype)initWithCompletion:(DPActionSheetCompletionBlock)completion
                             title:(NSString *)title
                 cancelButtonTitle:(NSString *)cancelButtonTitle
            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list otherTitles;
    va_start(otherTitles, otherButtonTitles);
    
    self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    
    if (self)
    {
        self.delegate = self;
        
        for (NSString *otherTitle = otherButtonTitles; otherTitle; otherTitle = va_arg(otherTitles, NSString*))
        {
            [self addButtonWithTitle:otherTitle];
        }
        
        _completion = [completion copy];
        
        [actionSheets addObject:self];
    }
    
    va_end(otherTitles);
    
    return self;
}

- (void)showInView:(UIView *)view
{
    [self addButtonWithTitle:@""];
    [super showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _completion(self, buttonIndex);
    [actionSheets removeObject:self];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheets removeObject:self];
}

@end
