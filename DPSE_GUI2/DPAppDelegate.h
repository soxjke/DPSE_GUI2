//
//  DPAppDelegate.h
//  DPSE_GUI2
//
//  Created by Petro Korienev on 12/2/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)isHostReachable;

@end
