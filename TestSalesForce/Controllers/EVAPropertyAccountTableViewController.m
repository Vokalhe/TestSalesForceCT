//
//  EVAPropertyAccountTableViewController.m
//  TestSalesForce
//
//  Created by ctuser on 11/21/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import "EVAPropertyAccountTableViewController.h"
#import "EVAAccountsTableViewController.h"

#import "EVAAccountPropertyTableViewCell.h"
#import "zkSforce.h"
#import "ChangeAccount+CoreDataClass.h"

@interface EVAPropertyAccountTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) EVAAccountPropertyTableViewCell *cell;
@property (assign, nonatomic) BOOL isChange;

@end

@implementation EVAPropertyAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChange = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) dealloc{
    [self.view endEditing:YES];
    
    if (self.isChange) {
        [[EVADataManager sharedManager] addChangeValuesToChangeAccount:self.accountTap];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EVAAccountPropertyTableViewCell";
    
    EVAAccountPropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EVAAccountPropertyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.accountTap) {
        cell.ibPhone.text = self.accountTap.phone;
        cell.ibWebSite.text = self.accountTap.website;
        cell.ibImageView.hidden = YES;
        cell.ibTextLabel.hidden = YES;
    }
    

    self.cell = cell;
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    self.isChange = YES;

    if (self.accountTap) {
        return YES;
    }else{
        return NO;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{

    self.isChange = YES;
    
        if (textField == self.cell.ibWebSite) {
    
            [[EVADataManager sharedManager] updateValue:self.cell.ibWebSite.text inProperty:@"website" inAccount:self.accountTap];
    
        }else if (textField == self.cell.ibPhone){
    
            [[EVADataManager sharedManager] updateValue:self.cell.ibPhone.text inProperty:@"phone" inAccount:self.accountTap];
    
        }
    
    [[EVADataManager sharedManager] addChangeValuesToChangeAccount:self.accountTap];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
    
}

@end
