//
//  DPGraphNet+DPPropertiesPanelElement.m
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

#import "DPGraphNet+DPPropertiesPanelElement.h"

@implementation DPGraphNet (DPPropertiesPanelElement)

- (NSUInteger)numberOfPropertyGroups
{
    return 2;
}

- (NSString*)captionForPropertyGroup:(NSUInteger)group
{
    if (group == 0) return @"Topology";
    else if (group == 1) return @"Physical attributes";
    return 0;
}

- (NSUInteger)numberOfPropertiesInGroup:(NSUInteger)group
{
    if (group == 0) return 3;
    else if (group == 1) return 3;
    return 0;
}

- (DPPropertiesPanelFieldType)panelFieldTypeAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) return DPPropertiesPanelFieldTypeTextfield;
        else if (indexPath.row == 1) return DPPropertiesPanelFieldTypeTextfield;
        else if (indexPath.row == 2) return DPPropertiesPanelFieldTypeSwitch;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return DPPropertiesPanelFieldTypeTextfield;
        else if (indexPath.row == 1) return DPPropertiesPanelFieldTypeTextfield;
        else if (indexPath.row == 2) return DPPropertiesPanelFieldTypeTextfield;
    }
    return 0;
}

- (NSString*)panelFieldCaptionAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) return @"x:";
        else if (indexPath.row == 1) return @"y:";
        else if (indexPath.row == 2) return @"Tied to topology";
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return @"Flow inertion";
        else if (indexPath.row == 1) return @"Resistance";
        else if (indexPath.row == 2) return @"Delta pressure";
    }
    return nil;
}

- (NSString*)panelFieldValueKeypathAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return kFlowInertionQuotientKey;
        else if (indexPath.row == 1) return kTotalResistanceKey;
        else if (indexPath.row == 2) return kDeltaPressureKey;
    }
    return nil;
}

- (DPPropertiesPanelFieldValueType)panelFieldValueTypeAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0)
    {
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return DPPropertiesPanelFieldValueTypeFloat;
        else if (indexPath.row == 1) return DPPropertiesPanelFieldValueTypeFloat;
        else if (indexPath.row == 2) return DPPropertiesPanelFieldValueTypeFloat;
    }
    return 0;
}

- (CGFloat)minPanelFieldValueAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0)
    {
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return 0.0f;
        else if (indexPath.row == 1) return 0.0f;
        else if (indexPath.row == 2) return -INFINITY;
    }
    return 0;
}

- (CGFloat)maxPanelFieldValueAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0)
    {
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return INFINITY;
        else if (indexPath.row == 1) return INFINITY;
        else if (indexPath.row == 2) return INFINITY;
    }
    return 0;
}

@end
