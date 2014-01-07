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
    return 3;
}

- (NSString*)captionForPropertyGroup:(NSUInteger)group
{
    if (group == 0) return @"General";
    else if (group == 1) return @"Topology";
    else if (group == 2) return @"Physical attributes";
    return 0;
}

- (NSUInteger)numberOfPropertiesInGroup:(NSUInteger)group
{
    if (group == 0) return 1;
    else if (group == 1) return 2;
    else if (group == 2) return 4;
    return 0;
}

- (DPPropertiesPanelFieldType)panelFieldTypeAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) return DPPropertiesPanelFieldTypeTextfield;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return DPPropertiesPanelFieldTypeLabel;
        else if (indexPath.row == 1) return DPPropertiesPanelFieldTypeLabel;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) return DPPropertiesPanelFieldTypeTextfield;
        else if (indexPath.row == 1) return DPPropertiesPanelFieldTypeTextfield;
        else if (indexPath.row == 2) return DPPropertiesPanelFieldTypeTextfield;
        else if (indexPath.row == 3) return DPPropertiesPanelFieldTypeTextfield;
    }
    return 0;
}

- (NSString*)panelFieldCaptionAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) return @"Name label";
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return @"Start node";
        else if (indexPath.row == 1) return @"End node";
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) return @"Flow inertion";
        else if (indexPath.row == 1) return @"Resistance";
        else if (indexPath.row == 2) return @"Delta pressure";
        else if (indexPath.row == 3) return @"Initial flow";
    }
    return nil;
}

- (NSString*)panelFieldValueKeypathAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) return kNameLabelKey;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return kStartNodeKey;
        else if (indexPath.row == 1) return kEndNodeKey;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) return kFlowInertionQuotientKey;
        else if (indexPath.row == 1) return kTotalResistanceKey;
        else if (indexPath.row == 2) return kDeltaPressureKey;
        else if (indexPath.row == 3) return kInitialFlowKey;
    }
    return nil;
}

- (DPPropertiesPanelFieldValueType)panelFieldValueTypeAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) return DPPropertiesPanelFieldValueTypeString;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) return DPPropertiesPanelFieldValueTypeString;
        else if (indexPath.row == 1) return DPPropertiesPanelFieldValueTypeString;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) return DPPropertiesPanelFieldValueTypeFloat;
        else if (indexPath.row == 1) return DPPropertiesPanelFieldValueTypeFloat;
        else if (indexPath.row == 2) return DPPropertiesPanelFieldValueTypeFloat;
        else if (indexPath.row == 3) return DPPropertiesPanelFieldValueTypeFloat;
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
        
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) return 0.0f;
        else if (indexPath.row == 1) return 0.0f;
        else if (indexPath.row == 2) return -INFINITY;
        else if (indexPath.row == 3) return -INFINITY;
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
        
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) return INFINITY;
        else if (indexPath.row == 1) return INFINITY;
        else if (indexPath.row == 2) return INFINITY;
        else if (indexPath.row == 3) return INFINITY;
    }
    return 0;
}

@end
