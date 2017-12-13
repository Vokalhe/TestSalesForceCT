//
//  EVAAccountsTableViewController.m
//  TestSalesForce
//
//  Created by ctuser on 11/21/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import "EVAAccountsTableViewController.h"
#import "zkSforce.h"
#import "EVAPropertyAccountTableViewController.h"
#import "EVAPopoverCreateFormController.h"

@interface EVAAccountsTableViewController () <UIPopoverControllerDelegate>

//@property(strong, nonatomic) UIPopoverController *popSort;

@property (nonatomic, strong) UIPopoverController *popController;

@end

@implementation EVAAccountsTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionSynchronizedByTap) name:@"createNewAccount" object:nil];

}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
-(void) viewWillLayoutSubviews{
    
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [Account MR_findAll].count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AccountCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    Account *accountCD = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = accountCD.name;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EVAPropertyAccountTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EVAPropertyAccountTableViewController"];
    vc.accountTap = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

    [self.splitViewController showDetailViewController:nav sender:nil];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[EVADataManager sharedManager] deleteAccount:[self.fetchedResultsController objectAtIndexPath:indexPath] success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        
        /*[[EVAServerManager sharedManager] deleteAccount:[self.fetchedResultsController objectAtIndexPath:indexPath] success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];*/
        /*NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }*/
        
    }
}

#pragma mark - Private Methods
/*
 -(void) createAlertForSort{
    
    int i = 0;
    NSArray *items = @[@"Sort by time", @"Sort by priority", @"Sort by folder"];
    self.arraySort = items;
    self.arraySortImages = @[@"TimeAlert.png", @"PriorityAlert.png", @"FolderAlert.png"];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *item in items) {
        
        UIAlertAction* defaultAction = [UIAlertAction
                                        actionWithTitle:item
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [self didSelectRowInSortAlertController:i];
                                        }];
        [defaultAction setValue:[[UIImage imageNamed:[self.arraySortImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        
        [alert addAction:defaultAction];
        i++;
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        self.isShowSortAlert = NO;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.popSort dismissPopoverAnimated:YES];
        }else{
            [self.sortView dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alert addAction:cancelAction];
    
    self.sortView = alert;
    
}
*/
#pragma mark - Actions
- (IBAction)actionAddNewAccount:(id)sender {
    
   /* UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add new:"
                                                                              message: @"Account"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleLine;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Website";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleBezel;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Phone";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        for (UITextField *tf in textfields){
            
            [dict setValue:tf.text forKey:[tf.placeholder lowercaseString]];
            
        }
        
        [[EVADataManager sharedManager] createAccountInCD:dict success:^{
            //[[NSNotificationCenter defaultCenter] postNotificationName:NotificationSynchronized object:nil];
            [self actionSynchronizedByTap];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];*/
    
    if (self.popController.popoverVisible) {
        [self.popController dismissPopoverAnimated:YES];
        return;
    }
    
    EVAPopoverCreateFormController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EVAPopoverCreateFormController"];
    
    contentViewController.view.backgroundColor = [UIColor yellowColor];
    UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
    popController.popoverContentSize = CGSizeMake(300.0f, 190.0f);
    popController.delegate = self;
    self.popController = popController;
    [self.popController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp                                                animated:YES];
    
}

- (IBAction)actionSynchronized:(id)sender {
    
    [self.view endEditing:YES];
    
    @try {
        
        [[EVADataManager sharedManager] addChangeValuesToChangeAccount:[self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]]];

        [self getAccounts:^{
            [self actionSynchronizedByTap];
        }];
        
    }
    
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    
}

-(void)actionSynchronizedByTap{
    
    NSFetchRequest *fetchRequest = [Account MR_requestAllSortedBy:@"name" ascending:YES];
    
    self.fetchedResultsController = [Account MR_fetchController:fetchRequest delegate:self useFileCache:nil groupedBy:nil inContext:self.managedObjectContext];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

#pragma mark - UIPopoverControllerDelegate
-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    self.popController = nil;
}
@end
