//
//  JBCoreDataAgent.m
//  Created by Jeremy Bueler on 8/12/13.
//

#import "JBCoreDataAgent.h"

@implementation JBCoreDataAgent

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize  persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize controllers = _controllers;


-(id) init{
	return  [self initWithStoreName: @"DataModel"];
}

-(id) initWithStoreName:(NSString *)storeName{
	if ( self == [super init]) {
		_storeName = storeName;
	}
	[self managedObjectContext];
	_controllers = [[NSMutableDictionary alloc] init];
	return self;
}


- (void)saveContext {
	NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//	NSLog(@"Do we have an MOC? %@", managedObjectContext);
	if (managedObjectContext != nil) {
//		NSLog(@"Yup...");
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be usefdul during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	} else {
//		NSLog(@"Nope.");
	}
}

- (NSURL *)storePathURL {
	NSString *storeName = [[NSString alloc] initWithFormat:@"%@.sqlite", _storeName];
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeName];
	return storeURL;
}


- (void) deleteLocalStore {
	// Delete the sqlite file.
	NSFileManager *fileMan = [NSFileManager defaultManager];
	NSError *error = nil;
	NSURL *storeURL = [self storePathURL];
	BOOL removeSuccess = [fileMan removeItemAtURL:storeURL error:&error];
	if (removeSuccess) {
		NSLog(@"File removed: %@", [storeURL path]);
	} else {
		NSLog(@"File not removed: %@", [storeURL path]);
	}
	if (error) {
		removeSuccess = NO;
		NSLog(@"Error removing asset at path: %@\n\t%@", [storeURL path], [error localizedDescription]);
	}

	// Reset ivars to nil.
	if (removeSuccess) {
		_managedObjectContext = nil;
		_managedObjectModel = nil;
		if (_persistentStoreCoordinator != nil) _persistentStoreCoordinator = nil;
	}
}


#pragma mark - Setup Fetched Results Controller
-(NSFetchedResultsController *) fetchedResultsControllerWithEntityName:(NSString *)entityName{
	return [self fetchedResultsControllerWithEntityName:entityName sortByKey:nil];
}

-(NSFetchedResultsController *) fetchedResultsControllerWithEntityName: (NSString *) entityName sortByKey: (NSString *)sortKey{
	return [self fetchedResultsControllerWithEntityName: entityName sortByKey:sortKey sectionNameKeyPath:nil andDelegate: self];
}

-(NSFetchedResultsController *) fetchedResultsControllerWithEntityName: (NSString *) entityName sortByKey:(NSString *)sortKey sectionNameKeyPath: (NSString *) sectionNameKeyPath andDelegate: (id) delegate{
	if ([_controllers valueForKey:entityName] != nil ){
		return [_controllers valueForKey:entityName];
	}
	
	//	CREATE FETCH REQUEST
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	//	CREATE ENTITY DESCRIPTION - THE MODEL WE ARE FETCHING
	NSEntityDescription *entity = [NSEntityDescription entityForName: entityName inManagedObjectContext: _managedObjectContext];
	[fetchRequest setEntity:entity];
	
	//	SET THE SORT ORDER OF THE RECORD SET
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: sortKey ascending: YES];
	[fetchRequest setSortDescriptors:@[sort]];
	
	//	AND THE BATCH SIZE BASICALLY THE SQL LIMIT
	[fetchRequest setFetchBatchSize:20];

	NSLog(@"sectionNameKeyPath = %@", sectionNameKeyPath);
	//	CREATE THE FETCHED RESULTS CONTROLLER AND RETURN IT
	NSFetchedResultsController *fetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath: @"name" cacheName: @"Root"];
	fetchedController.delegate = delegate;
	[_controllers setValue:fetchedController forKey:entityName];
//	NSLog(@"CONTROLLERS %@",_controllers);
	return fetchedController;
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		_managedObjectContext = [[NSManagedObjectContext alloc] init];
		[_managedObjectContext setPersistentStoreCoordinator:coordinator];
	}
	
//	NSLog(@"MOC staleness:%f", [_managedObjectContext stalenessInterval]);
	[_managedObjectContext setStalenessInterval:0.0];
//	NSLog(@"MOC staleness:%f", [_managedObjectContext stalenessInterval]);
	
	return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_storeName withExtension:@"momd"];
	if (!modelURL) {
		modelURL = [[NSBundle mainBundle] URLForResource:_storeName withExtension:@"mom"];
	}
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 
 No versioning check right now.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	NSURL *storeURL = [self storePathURL];
	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible;
		 * The schema for the persistent store is incompatible with current managed object model.
		 Check the error message to determine what the actual problem was.
		 
		 
		 If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
		 
		 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
		 * Simply deleting the existing store:
		 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
		 
		 * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
		 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
		 
		 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
		 
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

# pragma mark - Create Edit Delete Entities
-(void) performFetchForEntityOfName:(NSString *)entityName{
	NSFetchedResultsController *frc = [self fetchedResultsControllerWithEntityName: entityName];
	if (!frc) {
		frc = [self fetchedResultsControllerWithEntityName: entityName];
	}
	NSError *error;
	if (frc == nil || ![frc performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1); // FAIL
	}
}

-(NSManagedObject *) insertEntityWithName:(NSString *)name{
	NSLog(@"Managed Object Context %@", _managedObjectContext);
	return [NSEntityDescription insertNewObjectForEntityForName: name inManagedObjectContext: _managedObjectContext];
}

-(NSManagedObject *) fetchEntityOfName:(NSString *)entityName atIndexPath:(NSIndexPath *)indexPath{
	NSFetchedResultsController *frc = [self fetchedResultsControllerWithEntityName: entityName];
	return [frc objectAtIndexPath:indexPath];
}

-(NSString *) sectionTitle:(NSString *)entityName forSection:(NSUInteger)section{
	id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfo:section ofEntity:entityName];
	if (sectionInfo) {
		return [sectionInfo name];
	}
	else{
		return nil;
	}
}

-(id <NSFetchedResultsSectionInfo>) sectionInfo: (NSUInteger) section ofEntity:(NSString *) entityName{
	NSFetchedResultsController *frc = [self fetchedResultsControllerWithEntityName:entityName];
	
	if ([[frc sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex:section];
        return sectionInfo;
    }
	else{
        return nil;
	}
}

-(NSUInteger) numberOfSectionsForEntity:(NSString *)entityName{
	NSFetchedResultsController *frc = [self fetchedResultsControllerWithEntityName: entityName];
	return [frc.sections count];
}

-(NSUInteger) numberOfObjectsForSection:(NSInteger)section withName:(NSString *)entityName{
	if ([self numberOfSectionsForEntity:entityName] > 0) {
		NSFetchedResultsController *frc = [self fetchedResultsControllerWithEntityName: entityName];
		id sectionInfo = [frc.sections objectAtIndex: section];
		return [sectionInfo numberOfObjects];
	}
	else{
		return 0;
	}
}

-(NSUInteger) numberOfObjectsForEntity: (NSString *) entityName{
	NSFetchedResultsController *frc = [self fetchedResultsControllerWithEntityName: entityName];
	return [frc.fetchedObjects count];
}



@end
