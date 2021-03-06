//
//  DPDrawObjectsScrollView.h
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

#import <UIKit/UIKit.h>

@protocol DPDrawObjectsScrollViewDelegate;

@class DPGraphNet;
@class DPGraphNode;

@interface DPDrawObjectsScrollView : UIScrollView

@property (nonatomic, weak) IBOutlet id <DPDrawObjectsScrollViewDelegate> touchDelegate;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, strong) UIGestureRecognizer *contentTapRecognizer;

@property (nonatomic) BOOL zoomEnabled;
@property (nonatomic, strong) UIColor *netDrawColor;

- (void)extendContentHorizontally;
- (void)extendContentVertically;

@end

@protocol DPDrawObjectsScrollViewDelegate <NSObject>

@required
- (BOOL)scrollView:(DPDrawObjectsScrollView*)scrollView shouldBeginTouches:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL)scrollView:(DPDrawObjectsScrollView*)scrollView shouldMoveTouches:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL)scrollView:(DPDrawObjectsScrollView*)scrollView shouldEndTouches:(NSSet*)touches withEvent:(UIEvent*)event;
- (BOOL)scrollView:(DPDrawObjectsScrollView*)scrollView shouldAllowRecognitionForContentRecognizer:(UIGestureRecognizer*)recognizer;

- (void)scrollView:(DPDrawObjectsScrollView*)scrollView didDrawNode:(DPGraphNode*)node;
- (void)scrollView:(DPDrawObjectsScrollView*)scrollView didDrawNet:(DPGraphNet*)net;

- (void)scrollView:(DPDrawObjectsScrollView*)scrollView didSelectNode:(DPGraphNode*)node;
- (void)scrollView:(DPDrawObjectsScrollView*)scrollView didSelectNet:(DPGraphNet*)net;

@end