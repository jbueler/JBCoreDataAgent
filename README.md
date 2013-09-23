JBCoreDataAgent
===============
CoreDataAgent - Helps wrangle all core data methods into one tidy little package. Makes adding core data to an existing project very simple. Creates NSFetchRequests and NSFetchedResultsControllers, quickly and easily

##### To install
**Cocoapods** [Visit cocoapods.org for installation instructions](http://cocoapods.org)

Add this to your Podfile.

    pod 'JBCoreDataAgent', git: "https://github.com/jbueler/JBCoreDataAgent", tag: '0.0.3'

**Without cocoapods**
Download the .h & .m files. Add them to your project. Make sure you add the CoreData framework if you don't already have it in the project. You will also need a datamodel file, where your entities are setup.


#### To Do:

* Add NSFetchRequest & NSFetchedResultsController management (create the ability to store multiple FRCs & FRs) within the CoreDataAgent.


#### Implementation
========
Once JBCoreDataAgent is included into the project and you have a `DataModel.xcdatamodeld` file with your entities described in it. You can import `JBCoreDataAgent.h`

  
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
      // Allocate and initialize the CoreDataObject 
      JBCoreDataAgent *coreDataAgent = [[JBCoreDataAgent alloc] initWithStoreName:@"<#DataModel#>" andDelegate: <#NSFetchedResultsControllerDelegate#>];
      
      //Create a NSFetchRequest
      NSFetchRequest *fetchRequest = [coreDataAgent fetchRequest:@"<#EntityName#>" andSort:@"<#entity_attribute_to_sort_by#>" ascending:<#true#>];
      
      // Once you have the fetchRequest you can either perform the fetch with it, or create a NSFetchedResultsController and perform the fetch that way.
      //Perform fetch with fetchRequest
      // NSArray *resultsArray = [coreDataAgent performFetchWithFetchRequest: fetchRequest];
      
      // OR       
      // Perform fetch with NSFetchedResultsController (Good when dealing with UITableViews)
      NSFetchedResultsController *frc = [coreDataAgent fetchedResultsControllerWithFetchRequest: fetchRequest];
      [coreDataAgent performFetchWithFetchResultsController: frc];

      // DO WHATEVER YOU WANT ... 

      return YES;
    }


### Credit to:
Dru Kepple for kicking ass and coming up with this idea. https://github.com/drukepple

