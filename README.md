JBCoreDataAgent
===============

JBCoreDataAgent is meant to be an abstract class used to create subclasses to interface with a specific datamodel. JBCoreDataAgent can technically be used generically, but I do not think this would be the best use of it.

#### Need to add
* More helpers for adding, editing and deleting entities.
* Configure batch size in the fetchedResultsController.


#### Implementation
========
include JBCoreDataAgent in the project. In the app delegate or view controller `#import "JBCoreData.h"` make sure you have a `DataModel.xcdatamodeld` file. 
	
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		// Allocate and initialize the CoreDataObject 
		_coreDataAgent = [[JBCoreDataAgent alloc] initWithStoreName:@"DataModel"];
		
		// create a fetchedResultsController for an entity and a sortBy Key
		[_coreDataAgent fetchedResultsControllerWithEntityName:@"Person" sortByKey:@"lastname"];
		
		// Here you can assign create a reference to your root view controller
		MainViewController *vc = (MainViewController *) self.window.rootViewController;
		
		// Set the root views coreDataAgent to to the one created here in the appDelegate 
		[vc setCoreDataAgent: _coreDataAgent];		
		return YES;
	}


### Credit to:
Dru Kepple for kicking ass and coming up with this idea. https://github.com/drukepple

