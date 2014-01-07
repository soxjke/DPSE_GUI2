//
//  DPPropertiesPanelViewController.m
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/2/14.

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

#import "DPPropertiesPanelViewController.h"

#import "DPPropertiesPanelElement.h"

#import "DPPropertiesPanelTextfieldCell.h"
#import "DPPropertiesPanelSwitchCell.h"
#import "DPPropertiesPanelSliderCell.h"

#import "DPTableViewHeader.h"

#define INDEX_PATH_TO_TAG(indexPath) (indexPath.section << 16) + indexPath.row
#define TAG_TO_INDEXPATH(tag) [NSIndexPath indexPathForRow:(tag) & 0xFFFF inSection:(tag) >> 16]

@interface DPPropertiesPanelViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    __weak id <DPPropertiesPanelElement> _propertiesPanelElement;
}

@property (nonatomic, weak) IBOutlet UITableView    *table;
@property (nonatomic, weak) IBOutlet UILabel        *nothingSelectedLabel;

- (IBAction)switchValueChanged:(UISwitch *)sender;
- (IBAction)sliderValueChanged:(UISlider *)sender;

@end

@implementation DPPropertiesPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.table registerClass:[DPTableViewHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([DPTableViewHeader class])];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.nothingSelectedLabel.hidden = (BOOL)_propertiesPanelElement;
    return [_propertiesPanelElement numberOfPropertyGroups];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *cap = [_propertiesPanelElement captionForPropertyGroup:section];
    return cap.length ? [DPTableViewHeader height] : 0.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DPTableViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([DPTableViewHeader class])];
    header.text = [_propertiesPanelElement captionForPropertyGroup:section];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_propertiesPanelElement numberOfPropertiesInGroup:section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger tag = INDEX_PATH_TO_TAG(indexPath);
    NSString *caption = [_propertiesPanelElement panelFieldCaptionAtIndexPath:indexPath];
    
    switch ([_propertiesPanelElement panelFieldTypeAtIndexPath:indexPath])
    {
        case DPPropertiesPanelFieldTypeSwitch:
        {
            DPPropertiesPanelSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DPPropertiesPanelSwitchCell class])
                                                                                forIndexPath:indexPath];
            cell.switchControl.tag = tag;
            cell.fieldNameLabel.text = caption;
            
            return cell;
        }
        case DPPropertiesPanelFieldTypeTextfield:
        {
            DPPropertiesPanelTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DPPropertiesPanelTextfieldCell class])
                                                                                   forIndexPath:indexPath];
            cell.textField.tag = tag;
            
            DPPropertiesPanelFieldValueType valueType = [_propertiesPanelElement panelFieldValueTypeAtIndexPath:indexPath];
            
            if (valueType == DPPropertiesPanelFieldValueTypeFloat || valueType == DPPropertiesPanelFieldValueTypeInteger)
            {
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            else
            {
                cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            }
            
            cell.fieldNameLabel.text = caption;
            
            return cell;
        }
        case DPPropertiesPanelFieldTypeSlider:
        {
            DPPropertiesPanelSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DPPropertiesPanelSliderCell class])
                                                                                   forIndexPath:indexPath];
            cell.slider.tag = tag;
            cell.fieldNameLabel.text = caption;
            
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate implementation

#pragma mark - getter/setter

- (void)setPropertiesPanelElement:(id<DPPropertiesPanelElement>)propertiesPanelElement
{
    if (_propertiesPanelElement != propertiesPanelElement)
    {
        _propertiesPanelElement = propertiesPanelElement;

        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [self.table reloadData];
        });
    }
}

- (id <DPPropertiesPanelElement>)propertiesPanelElement
{
    return _propertiesPanelElement;
}

#pragma mark - cell controls

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([_propertiesPanelElement respondsToSelector:@selector(validatorRegexForValueAtIndexPath:)])
    {
        NSString *regex = [_propertiesPanelElement validatorRegexForValueAtIndexPath:TAG_TO_INDEXPATH(textField.tag)];
        if (regex)
        {
            return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:newText];
        }
    }
    
    if ([_propertiesPanelElement respondsToSelector:@selector(allowedCharactersForPanelFieldValueAtIndexPath:)])
    {
        NSCharacterSet *allowedCharacters = [_propertiesPanelElement allowedCharactersForPanelFieldValueAtIndexPath:TAG_TO_INDEXPATH(textField.tag)];
        if (allowedCharacters)
        {
            NSCharacterSet *newTextCharacterSet = [NSCharacterSet characterSetWithCharactersInString:newText];
            if (![allowedCharacters isSupersetOfSet:newTextCharacterSet])
            {
                return NO;
            }
        }
    }
    if ([_propertiesPanelElement respondsToSelector:@selector(restrictedCharactersForPanelFieldValueAtIndexPath:)])
    {
        NSCharacterSet *restrictedCharacters = [_propertiesPanelElement restrictedCharactersForPanelFieldValueAtIndexPath:TAG_TO_INDEXPATH(textField.tag)];
        if (restrictedCharacters)
        {
            NSCharacterSet *newTextCharacterSet = [NSCharacterSet characterSetWithCharactersInString:newText];
            if ([restrictedCharacters isSupersetOfSet:[newTextCharacterSet invertedSet]])
            {
                return NO;
            }
        }
    }
   
    return YES;
}

@end
