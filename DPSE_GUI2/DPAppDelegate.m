//
//  DPAppDelegate.m
//  DPSE_GUI2
//
//  Created by Petro Korienev on 12/2/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#import "DPAppDelegate.h"

#import "DPMasterViewController.h"

#import "Reachability.h"

@interface DPAppDelegate ()
{
    Reachability *_reachability;
}

@end

@implementation DPAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
#endif

    // Was ist einmal einzustellen...
    [self setupReachability];
    [DPSSHConnection sharedObject];
    
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;

    UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
    DPMasterViewController *controller = (DPMasterViewController *)masterNavigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

#pragma mark - Core Data stack

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSAssert(NO, @"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DPSE_GUI2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DPSE_GUI2.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:@{NSMigratePersistentStoresAutomaticallyOption:@YES,
                                                                   NSInferMappingModelAutomaticallyOption:@YES}
                                                           error:&error]) {
        NSAssert(NO, @"Unresolved error %@, %@", error, [error userInfo]);
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - reachability

- (void)setupReachability
{
    _reachability = [Reachability reachabilityWithHostName:[DPSSHConnection sharedObject].hostname];
}

- (BOOL)isHostReachable
{
    if (_reachability.currentReachabilityStatus)
    {
        [_reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityDidChange:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    return _reachability.currentReachabilityStatus;
}

- (void)reachabilityDidChange:(NSNotification __unused *)note
{
    if (_reachability.currentReachabilityStatus)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
        [_reachability stopNotifier];
    }
}

#pragma mark - debug

#ifdef DEBUG
void uncaughtExceptionHandler(NSException *ex)
{
    NSLog(@"CRASH :\n %@", ex.reason);
    NSLog(@"STACK TRACE :\n %@", ex.callStackSymbols);
    exit(0);
}
#endif

@end
