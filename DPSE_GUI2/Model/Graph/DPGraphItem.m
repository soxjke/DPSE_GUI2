//
//  DPGrapthItem.m
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

#import "DPGraphItem.h"

NSString * const kNameLabelKey = @"nameLabel";

@implementation DPGraphItem

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.itemAttributes = [NSMutableDictionary new];
        self.itemAttributes[kNameLabelKey] = [[[NSUUID UUID] UUIDString] substringToIndex:8];
        self.isConcentratedParameters = YES;
    }
    return self;
}

- (NSArray*)knownKeyPaths
{
    NSAssert(NO, @"Called %s on abstract class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([self.knownKeyPaths indexOfObject:key] != NSNotFound)
    {
        [self.itemAttributes setValue:value forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    if ([self.knownKeyPaths indexOfObject:keyPath] != NSNotFound)
    {
        [self.itemAttributes setValue:value forKeyPath:keyPath];
        return;
    }
    NSArray *comps = [keyPath componentsSeparatedByString:@"."];
    if (comps.count > 1)
    {
        [[self valueForKeyPath:comps[0]] setValue:value forKeyPath:[[comps subarrayWithRange:NSMakeRange(1, comps.count - 1)] componentsJoinedByString:@"."]];
    }
    [super setValue:value forKeyPath:keyPath];
}

- (id)valueForKey:(NSString *)key
{
    if ([self.knownKeyPaths indexOfObject:key] != NSNotFound)
    {
        return [self.itemAttributes valueForKey:key];
    }
    return [super valueForKey:key];
}

- (id)valueForKeyPath:(NSString *)keyPath
{
    if ([self.knownKeyPaths indexOfObject:keyPath] != NSNotFound)
    {
        return [self.itemAttributes valueForKeyPath:keyPath];
    }
    NSArray *comps = [keyPath componentsSeparatedByString:@"."];
    if (comps.count > 1)
    {
        return [[self valueForKeyPath:comps[0]] valueForKeyPath:[[comps subarrayWithRange:NSMakeRange(1, comps.count - 1)] componentsJoinedByString:@"."]];
    }
    return [super valueForKeyPath:keyPath];
}

- (NSString*)description
{
    return [[super description] stringByAppendingFormat:@", Name:%@", self.itemAttributes[kNameLabelKey]];
}

@end
