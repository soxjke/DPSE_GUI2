//
//  DPGraphItem+DPPropertiesPanelElement.m
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

#import "DPGraphItem+DPPropertiesPanelElement.h"

@implementation DPGraphItem (DPPropertiesPanelElement)

- (NSUInteger)numberOfPropertyGroups
{
    NSAssert(NO, @"Called %s on abstract class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return 0;
}

- (NSString*)captionForPropertyGroup:(NSUInteger)group
{
    NSAssert(NO, @"Called %s on abstract class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return 0;
}

- (NSUInteger)numberOfPropertiesInGroup:(NSUInteger)group
{
    NSAssert(NO, @"Called %s on abstract class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return 0;
}

- (DPPropertiesPanelFieldType)panelFieldTypeAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Called %s on abstract class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return 0;
}

- (NSString*)panelFieldCaptionAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Called %s on abstract class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return nil;
}

- (NSString*)panelFieldValueKeypathAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Called %s on abstract class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return nil;
}

- (NSString*)validatorRegexForValueAtIndexPath:(NSIndexPath *)indexPath
{
    DPPropertiesPanelFieldValueType valueType = [self panelFieldValueTypeAtIndexPath:indexPath];
    if (valueType == DPPropertiesPanelFieldValueTypeFloat)
    {
        return @"^([+-]?)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    }
    if (valueType == DPPropertiesPanelFieldValueTypeInteger)
    {
        return @"^([+-]?)(?:|0|[1-9]\\d*)?$";
    }
    return nil;
}

@end
