//
//  DPGraphNode+DPPropertiesPanelElement.m
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

#import "DPGraphNode+DPPropertiesPanelElement.h"

@implementation DPGraphNode (DPPropertiesPanelElement)

- (NSUInteger)numberOfPropertyGroups
{
    return 2;
}

- (NSUInteger)numberOfPropertiesInGroup:(NSUInteger)group
{
    if (group == 0) return 3;
    else if (group == 1) return 2;
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
        if (indexPath.row == 0) return @"ololo";
        else if (indexPath.row == 1) return @"ya voditel nlo";
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
        
    }
    return nil;
}

@end
