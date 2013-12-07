//
//  DPMasterViewController.h
//  DPSE_GUI2
//
//  Created by Petro Korienev on 12/2/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPDetailViewController;

#import <CoreData/CoreData.h>

@interface DPMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DPDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
