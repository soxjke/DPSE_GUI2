//
//  DPDetailViewController.h
//  DPSE_GUI2
//
//  Created by Petro Korienev on 12/2/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
