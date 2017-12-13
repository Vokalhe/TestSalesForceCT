//
//  EVACoreDataTableViewController.m
//  TestSalesForce
//
//  Created by ctuser on 11/22/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import "EVACoreDataTableViewController.h"

@interface EVACoreDataTableViewController ()

@end

//NSString *const NotificationSynchronized = @"NotificationSynchronized";

@implementation EVACoreDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) getAccounts:(void(^)(void)) success{
    
    [[EVADataManager sharedManager] synchronizedWithServerSuccess:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            if (![self.fetchedResultsController performFetch:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
            NSString *formattedDateString = [df stringFromDate:dateNow];
            [userDefaults setObject:formattedDateString forKey:@"date"];
            
            success();
            
        });
        
    }];
    
}

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[EVADataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [Account MR_requestAllSortedBy:@"name" ascending:YES];
    
    NSFetchedResultsController *aFetchedResultsController = [Account MR_fetchController:fetchRequest delegate:self useFileCache:nil groupedBy:nil inContext:self.managedObjectContext];
    
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
    
}
@end
