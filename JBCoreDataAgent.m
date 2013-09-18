//
//  CoreDataAgent.m
//  CoreDataAgent-Refactor
//
//  Created by Jeremy Bueler on 9/18/13.
//  Copyright (c) 2013 Jeremy Bueler. All rights reserved.
//

#import "JBCoreDataAgent.h"

@implementation JBCoreDataAgent

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize storeName = _storeName;
@synthesize delegate = _delegate;

#pragma mark - initialize
-(id) initWithStoreName:(NSString *)storeName andDelegate:(id)delegate{
	if ( self == [super init]) {
		_storeName = storeName;
		_delegate = (delegate) ? delegate : self;
	}
	[self managedObjectContext];
	return self;
}

- (NSURL *)storePathURL {
	NSString *storeName = [[NSString alloc] initWithFormat:@"%@.sqlite", _storeName];
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeName];
	return storeURL;
}

-(void) deleteCache{
	[NSFetchedResultsController deleteCacheWithName: _storeName];
}

#pragma mark - Fetching

#pragma mark Fetch Requests
-(NSFetchRequest *)fetchRequest: (NSString *) entityName{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName: entityName inManagedObjectContext: _managedObjectContext];
	[fetchRequest setEntity:entity];
	return fetchRequest;
}

-(NSFetchRequest *)fetchRequest: (NSString *) entityName andSort:(NSString *)sortKey ascending:(BOOL)direction{
	NSFetchRequest *fetchRequest = [self fetchRequest: entityName];
	
	//	SET THE SORT ORDER OF THE RECORD SET
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: sortKey ascending: direction];
	[fetchRequest setSortDescriptors:@[sort]];
	return fetchRequest;
}

-(NSFetchRequest *)fetchRequest: (NSString *) entityName andSort:(NSString *)sortKey ascending:(BOOL)direction andWithPredicate:(NSString *)predicateString, ...{
	NSFetchRequest * fetchRequest = [self fetchRequest:entityName andSort:sortKey ascending:direction];
	
	va_list args;
	va_start(args, predicateString);
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString arguments:args];
	va_end(args);
	
	[fetchRequest setPredicate:predicate];
	return fetchRequest;
}

-(NSArray *) performFetchWithFetchRequest: (NSFetchRequest *)fr{
	NSError *error = nil;
	NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fr error:&error];
	if (fetchedObjects == nil) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	return fetchedObjects;
	
}

#pragma mark FetchResultsController
-(NSFetchedResultsController *) fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest{
	//	AND THE BATCH SIZE BASICALLY THE SQL LIMIT
	[fetchRequest setFetchBatchSize:20];
	
	//	CREATE THE FETCHED RESULTS CONTROLLER AND RETURN IT
	NSFetchedResultsController *fetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath: nil cacheName: _storeName];
	fetchedController.delegate = _delegate;
	//	[_controllers setValue:fetchedController forKey:entityName];
	return fetchedController;
}

-(NSManagedObject *) objectAtIndexPath:(NSIndexPath *)indexPath inFetchedResultsController: (NSFetchedResultsController *)frc{
	return [frc objectAtIndexPath:indexPath];
}

-(void) performFetchWithFetchResultsController: (NSFetchedResultsController *)frc{
	NSError *error;
	if (frc == nil || ![frc performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1); // FAIL
	}
}



#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_storeName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [self storePathURL];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Save Context
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	NSLog(@"/* *****************************************");
	NSLog(@"ManagedObjectContext %@", managedObjectContext);
	NSLog(@"******************************************* */");

    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
		else{
			NSLog(@"/* *****************************************");
			NSLog(@"NO CHANGES IN <#%@#>", managedObjectContext);
			NSLog(@"******************************************* */");

		}
    }
}

#pragma mark - Creating Entities
/**
 * Creates and returns a given Entity for the default managed object context.
 */
- (NSManagedObject *) insertEntityWithName:(NSString *)name {
	return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext: _managedObjectContext];
}

#pragma mark - Delete entries
-(void) deleteObjectAtIndexPath:(NSIndexPath *)indexPath inFetchedResultsController:(NSFetchedResultsController *)frc{
	[_managedObjectContext deleteObject: [frc objectAtIndexPath:indexPath]];
}

@end

