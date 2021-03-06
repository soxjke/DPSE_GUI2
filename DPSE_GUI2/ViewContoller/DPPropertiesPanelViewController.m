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
#import "DPPropertiesPanelLabelCell.h"

#import "DPTableViewHeader.h"

#define INDEX_PATH_TO_TAG(indexPath) (indexPath.section << 16) + indexPath.row
#define TAG_TO_INDEXPATH(tag) [NSIndexPath indexPathForRow:(tag) & 0xFFFF inSection:(tag) >> 16]

@interface DPPropertiesPanelViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    __weak NSObject <DPPropertiesPanelElement> *_propertiesPanelElement;
    
    BOOL _shouldKeepOnScreenKeyboard;
    BOOL _shouldAccordingTextFieldBecomeFirstResponder;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    NSString *keyPath = [_propertiesPanelElement panelFieldValueKeypathAtIndexPath:indexPath];
    DPPropertiesPanelFieldValueType valueType = [_propertiesPanelElement panelFieldValueTypeAtIndexPath:indexPath];
    
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
            
            if (valueType == DPPropertiesPanelFieldValueTypeFloat || valueType == DPPropertiesPanelFieldValueTypeInteger)
            {
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text         = [[_propertiesPanelElement valueForKeyPath:keyPath] stringValue];
            }
            else
            {
                cell.textField.keyboardType = UIKeyboardTypeAlphabet;
                cell.textField.text         = [_propertiesPanelElement valueForKeyPath:keyPath];
            }
            
            cell.fieldNameLabel.text = caption;
            
            if (_shouldAccordingTextFieldBecomeFirstResponder)
            {
                _shouldAccordingTextFieldBecomeFirstResponder = NO;
                [cell.textField becomeFirstResponder];
            }
            
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
        case DPPropertiesPanelFieldTypeLabel:
        {
            DPPropertiesPanelLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DPPropertiesPanelLabelCell class])
                                                                               forIndexPath:indexPath];
            cell.fieldNameLabel.text = caption;
            
            if (valueType == DPPropertiesPanelFieldValueTypeFloat || valueType == DPPropertiesPanelFieldValueTypeInteger)
            {
                cell.valueLabel.text = [[_propertiesPanelElement valueForKeyPath:keyPath] stringValue];
            }
            else
            {
                cell.valueLabel.text = [_propertiesPanelElement valueForKeyPath:keyPath];
            }
            
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
            if (_shouldKeepOnScreenKeyboard) _shouldAccordingTextFieldBecomeFirstResponder = YES;
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

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

#pragma mark - notification observing

- (void)textDidChange:(NSNotification*)note
{
    UITextField *textField = note.object;
    
    NSString *keyPath = [_propertiesPanelElement panelFieldValueKeypathAtIndexPath:TAG_TO_INDEXPATH(textField.tag)];
    
    DPPropertiesPanelFieldValueType valueType = [_propertiesPanelElement panelFieldValueTypeAtIndexPath:TAG_TO_INDEXPATH(textField.tag)];
    
    switch (valueType)
    {
        case DPPropertiesPanelFieldValueTypeFloat:
            [_propertiesPanelElement setValue:@(textField.text.floatValue) forKeyPath:keyPath];
            break;
        case DPPropertiesPanelFieldValueTypeInteger:
            [_propertiesPanelElement setValue:@(textField.text.integerValue) forKeyPath:keyPath];
            break;
        case DPPropertiesPanelFieldValueTypeString:
            [_propertiesPanelElement setValue:textField.text forKeyPath:keyPath];
        default:
            break;
    }
}

- (void)keyboardDidShow:(NSNotification*)note
{
    _shouldKeepOnScreenKeyboard = YES;
}

- (void)keyboardDidHide:(NSNotification*)note
{
    _shouldKeepOnScreenKeyboard = NO;
}

@end
