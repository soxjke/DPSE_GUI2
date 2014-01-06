//
//  DPSettingsDictionary.m
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


#import "DPSettingsDictionary.h"

@interface DPSettingsDictionary ()
{
    NSMutableDictionary *_innerDict;
}

@end

@implementation DPSettingsDictionary

+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary
{
    self = [super init];
    if (self)
    {
        _innerDict = [[NSMutableDictionary alloc] initWithCapacity:otherDictionary.count];
        [otherDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                [_innerDict setObject:[DPSettingsDictionary dictionaryWithDictionary:obj] forKey:key];
            }
            else
            {
                [_innerDict setObject:obj forKey:key];
            }
        }];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _innerDict = [NSMutableDictionary new];
    }
    return self;
}

- (id)objectForKey:(id)aKey
{
    if ([aKey isKindOfClass:[NSString class]])
    {
        NSArray *comps = [aKey pathComponents];
        if (comps.count > 1)
        {
            DPSettingsDictionary *dict = [_innerDict objectForKey:comps[0]];
            if (![dict isKindOfClass:[DPSettingsDictionary class]])
            {
                return nil;
            }
            return [dict objectForKey:[NSString pathWithComponents:[comps subarrayWithRange:NSMakeRange(1, comps.count - 1)]]];
        }
        else
        {
            return [_innerDict objectForKey:aKey];
        }
    }
    return nil;
}

- (void)setObject:(id)object forKey:(id)aKey
{
    if ([aKey isKindOfClass:[NSString class]])
    {
        NSArray *comps = [aKey pathComponents];
        if (comps.count > 1)
        {
            DPSettingsDictionary *dict = [_innerDict objectForKey:comps[0]];
            if (![dict isKindOfClass:[DPSettingsDictionary class]])
            {
                dict = [DPSettingsDictionary new];
                [_innerDict setObject:dict forKey:comps[0]];
            }
            [dict setObject:object forKey:[NSString pathWithComponents:[comps subarrayWithRange:NSMakeRange(1, comps.count - 1)]]];
        }
        else
        {
            [_innerDict performSelector:object ? @selector(setObject:forKey:) : @selector(removeObjectForKey:) withObject:object ? object : aKey withObject:object ? aKey : nil];
        }
    }
}

- (NSUInteger)count
{
    return _innerDict.count;
}

- (NSEnumerator*)keyEnumerator
{
    return _innerDict.keyEnumerator;
}

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    [self setObject:obj forKey:key];
}

@end
