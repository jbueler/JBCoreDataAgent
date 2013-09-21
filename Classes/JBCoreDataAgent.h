//
//  JBCoreDataAgent.h
//  Created by Jeremy Bueler on 8/12/13.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//
//  JBCoreDataAgent.h

//  Created by Jeremy Bueler on 9/18/13.
//  Copyright (c) 2013 Jeremy Bueler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBCoreDataAgent : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) id delegate;

- (id) initWithStoreName:(NSString *)storeName andDelegate:(id)delegate;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) deleteCache;

#pragma mark - Creating Entities
- (NSManagedObject *) insertEntityWithName:(NSString *)name;

#pragma mark - Delete entries
-(void) deleteObjectAtIndexPath: (NSIndexPath *)indexPath inFetchedResultsController: (NSFetchedResultsController *) frc;

#pragma mark - Fetching
#pragma mark Fetch Requests
-(NSFetchRequest *)fetchRequest: (NSString *) entityName;
-(NSFetchRequest *)fetchRequest: (NSString *) entityName andSort:(NSString *)sortKey ascending:(BOOL)direction;
-(NSFetchRequest *)fetchRequest: (NSString *) entityName andSort:(NSString *)sortKey ascending:(BOOL)direction andWithPredicate:(NSString *)predicateString, ...;
-(NSArray *) performFetchWithFetchRequest: (NSFetchRequest *)fr;

#pragma mark FetchResultsController
-(NSFetchedResultsController *) fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest;
-(NSManagedObject *) objectAtIndexPath:(NSIndexPath *)indexPath inFetchedResultsController: (NSFetchedResultsController *)frc;
-(void) performFetchWithFetchResultsController: (NSFetchedResultsController *)frc;
@end
