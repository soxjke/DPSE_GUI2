//
//  DPGraphNode.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/3/14.

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


#import "DPGraphNode.h"

#import "DPAttributesManager.h"

NSString * const kCenterX = @"centerX";
NSString * const kCenterY = @"centerY";

@interface DPGraphNode ()
{
    CGPoint         _location;
    NSMutableArray  *_nets;
}

@property (nonatomic) NSNumber *centerX;
@property (nonatomic) NSNumber *centerY;

@end

@implementation DPGraphNode

+ (instancetype)nodeWithLocation:(CGPoint)nodeLocation
{
    return [[self alloc] initWithLocation:nodeLocation];
}

- (instancetype)initWithLocation:(CGPoint)nodeLocation
{
    self = [super init];
    if (self)
    {
        _nets       = [NSMutableArray new];
        _location   = nodeLocation;

        self.isConcentratedParameters = YES;
    }
    return self;
}

- (NSArray*)nets
{
    return [_nets copy];
}

- (void)connectNet:(DPGraphNet *)net
{
    [_nets addObject:net];
}

- (void)disconnectNet:(DPGraphNet *)net
{
    [_nets removeObject:net];
}

- (NSArray*)knownKeyPaths
{
    return self.isConcentratedParameters ? ATTRIBUTES_MANAGER.concentratedParametersNodeAttributes : ATTRIBUTES_MANAGER.distributedParametersNodeAttributes;
}

- (NSNumber*)centerX
{
    return @(_location.x);
}

- (NSNumber*)centerY
{
    return @(_location.y);
}

- (void)setCenterX:(NSNumber *)centerX
{
    [self willChangeValueForKey:kCenterX];
    _location.x = centerX.floatValue;
    [self didChangeValueForKey:kCenterX];
}

- (void)setCenterY:(NSNumber *)centerY
{
    [self willChangeValueForKey:kCenterY];
    _location.y = centerY.floatValue;
    [self didChangeValueForKey:kCenterY];
}

@end
