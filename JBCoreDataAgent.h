//
//  JBCoreDataAgent.h
//  Created by Jeremy Bueler on 8/12/13.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JBCoreDataAgent : NSObject{
	NSManagedObjectContext * _managedObjectContext;
	NSString *_storeName;
}

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

-(id) initWithStoreName: (NSString *)storeName;
-(void) saveContext;
-(NSURL *) applicationDocumentsDirectory;

-(NSFetchedResultsController *) fetchedResultsController;
-(NSFetchedResultsController *) fetchedResultsControllerWithEntityName: (NSString *)entityName sortByKey: (NSString *) sortKey;
-(NSFetchedResultsController *) fetchedResultsControllerWithEntityName: (NSString *) entityName sortByKey:(NSString *)sortKey andDelegate: (id) delegate;

//-(NSManagedObject *) insertEntityWIthName: (NSString *) name;
-(NSManagedObject *) createEntityWithName: (NSString *) name;
-(void) performFetch;

//
//-(NSFetchRequest *) fetchRequestWithEntityName: (NSString * ) name;
//-(NSArray *) fetchAllEntitiesOfName: (NSString *) name;
//-(NSArray *) fetchAllEntitiesOfName:(NSString *)name withPredicateString: (NSString *) predicateString, ...;


@end
