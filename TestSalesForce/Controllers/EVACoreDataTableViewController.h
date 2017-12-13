//
//  EVACoreDataTableViewController.h
//  TestSalesForce
//
//  Created by ctuser on 11/22/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account+CoreDataClass.h"
#import "EVADataManager.h"
#import "EVAServerManager.h"

#import <MagicalRecord/MagicalRecord.h>

@interface EVACoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

-(void) getAccounts:(void(^)(void)) success;
@end
