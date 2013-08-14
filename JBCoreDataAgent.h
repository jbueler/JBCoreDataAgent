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
@property (nonatomic, strong) NSMutableDictionary *controllers;


-(id) initWithStoreName: (NSString *)storeName;
-(void) saveContext;
-(NSURL *) applicationDocumentsDirectory;

-(NSFetchedResultsController *) fetchedResultsControllerWithEntityName: (NSString *) entityName;
-(NSFetchedResultsController *) fetchedResultsControllerWithEntityName: (NSString *)entityName sortByKey: (NSString *) sortKey;
-(NSFetchedResultsController *) fetchedResultsControllerWithEntityName: (NSString *) entityName sortByKey:(NSString *)sortKey andDelegate: (id) delegate;

-(NSManagedObject *) insertEntityWithName: (NSString *) name;
//-(NSManagedObject *) createEntityWithName: (NSString *) name;

-(void) performFetchForEntityOfName: (NSString *) entityName;
-(NSManagedObject *) fetchEntityOfName: (NSString *)entityName atIndexPath: (NSIndexPath *)indexPath;

-(NSString*) sectionTitle:(NSString *)entityName forSection:(NSUInteger) section;
-(id <NSFetchedResultsSectionInfo>) sectionInfo: (NSUInteger) section ofEntity:(NSString *) entityName;


-(NSUInteger) numberOfSectionsForEntity: (NSString *) entityName;
-(NSUInteger) numberOfObjectsForSection: (NSInteger) section withName: (NSString *) entityName;

//-(NSFetchRequest *) fetchRequestWithEntityName: (NSString * ) name;
//-(NSArray *) fetchAllEntitiesOfName: (NSString *) name;
//-(NSArray *) fetchAllEntitiesOfName:(NSString *)name withPredicateString: (NSString *) predicateString, ...;


@end
