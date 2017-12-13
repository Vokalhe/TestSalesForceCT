//
//  EVADataManager.m
//  TestSalesForce
//
//  Created by ctuser on 11/22/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import "EVADataManager.h"
#import "Account+CoreDataClass.h"
#import "ChangeAccount+CoreDataClass.h"
#import "EVAServerManager.h"
#import "zkSforce.h"
#import "EVAAccountFromServer.h"

static NSString *const kLocalIdForAccount = @"localId";

@implementation EVADataManager

@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - Singleton
+(EVADataManager*) sharedManager{
    static EVADataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EVADataManager alloc] init];
        [MagicalRecord setupCoreDataStackWithStoreNamed:@"TestSalesForce.sqlite"];

    });
    return manager;
}

#pragma mark - Standart Methods
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    _managedObjectContext = [NSManagedObjectContext MR_defaultContext];

    return _managedObjectContext;
}

#pragma mark - Save
- (void)saveContext {
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
}

#pragma mark - Work With Server
-(void) changeObjectAccountInServer{
    
    NSArray *resultArray = [ChangeAccount MR_findByAttribute:@"isChange" withValue:@YES];
    
    for (ChangeAccount *acc in resultArray) {
        
        NSDictionary *dict = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)acc.changedValuesByKey];
        
        if (dict.allKeys.count > 0) {
            Account *account = [[Account MR_findByAttribute:@"accountId" withValue:acc.changeAccountById] firstObject];
            [[EVAServerManager sharedManager] updateValueInAccount:account andDictChangedValues:dict];
        }
        
    }
    
}

-(void) createAccountsAndSentToServer {
    
    NSArray *resultArray = [Account MR_findByAttribute:@"accountId" withValue:kLocalIdForAccount];

    for (Account *acc in resultArray){
        
        [[EVAServerManager sharedManager] createNewAccount:acc success:^{
            [acc MR_deleteEntity];
        }];
        
    }
    
}

-(void) deleteAccountsFromServer{
    
    NSArray *resultArray = [ChangeAccount MR_findByAttribute:@"isDelete" withValue:@YES];
    
    for (ChangeAccount *changeAcc in resultArray){
        
        Account *account = [[Account MR_findByAttribute:@"accountId" withValue:changeAcc.changeAccountById] firstObject];
        [[EVAServerManager sharedManager] deleteAccount:account];

    }
    
}

#pragma mark - Work With Core Data
-(void) createAccountInCD:(NSDictionary*) dict success:(void(^)(void)) success{
    
    Account *addAccount = [Account MR_createEntity];
    
    for (NSString *key in dict){
        [addAccount setValue:[dict valueForKey:key] forKey:key];
    }
    
    addAccount.accountId = kLocalIdForAccount;
    
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    success();
    
}

-(void) deleteAccount:(Account*) account success:(void(^)(void)) success{
    
    NSArray *arrayAll = [ChangeAccount MR_findByAttribute:@"changeAccountById" withValue:account.accountId];
    ChangeAccount *accountChange = [arrayAll firstObject];
    accountChange.isDelete = YES;
    
    [account MR_deleteEntity];
    if ([account isDeleted]){
        [self saveContext];
        success();
    }
    
}

-(void) addChangeValuesToChangeAccount:(Account*) account{
    
    NSArray *arrayAll = [ChangeAccount MR_findByAttribute:@"changeAccountById" withValue:account.accountId];
    ChangeAccount *accountChange = [arrayAll firstObject];
    
    NSMutableDictionary *tempDict = (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData*) accountChange.changedValuesByKey];
    NSSet *set = (NSSet*)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)accountChange.changesValuesSet];
    
    if (account.changedValues.allKeys.count > 0) {
        for(NSString *key in account.changedValues.allKeys){
            NSString *value = [account.changedValues valueForKey:key];
            
            if ([set containsObject:value]){
                [tempDict removeObjectForKey:key];
            }else{
                [tempDict setValue:value forKey:key];
            }
            
        }
    }else {
        [tempDict removeAllObjects];
    }
    
    if (tempDict.allKeys.count > 0){
        for(NSString *key in tempDict.allKeys){
            NSString *value = [account valueForKey:key];
            
            if ([set containsObject:value]){
                [tempDict removeObjectForKey:key];
            }else{
                [tempDict setValue:value forKey:key];
            }
            
        }
    }
    
    if (tempDict.allKeys.count > 0) {
        accountChange.isChange = YES;
    }else{
        accountChange.isChange = NO;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tempDict];
    accountChange.changedValuesByKey = data;
    
}

#pragma mark - Update Value In Account
-(void) updateValue:(NSString*) value inProperty:(NSString*) property inAccount:(Account*) account{
    
    [account setValue:value forKey:property];
    
}

#pragma mark - Create Change Accounts
-(void) createChangeAccountsInData{
    
    NSArray *array = [Account MR_findAll];
    [ChangeAccount MR_truncateAll];
    for (Account *addAccount in array){
        ChangeAccount *accountChange = [ChangeAccount MR_createEntity];
        accountChange.changeAccountById = addAccount.accountId;
        
        NSSet *setOfKeys = [NSSet setWithObjects: addAccount.phone, addAccount.website, nil];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:setOfKeys];
        accountChange.changesValuesSet = data;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSData *dataDict = [NSKeyedArchiver archivedDataWithRootObject:dict];
        accountChange.changedValuesByKey = dataDict;
        
        accountChange.isChange = NO;
        accountChange.isDelete = NO;
    }
        
}


/*-(NSMutableArray*)allChangesAccounts{
    
    NSArray *accFull = [Account MR_findAll];
    NSArray *resultArray = [ChangeAccount MR_findAll];
    NSMutableArray *array = [NSMutableArray array];

    NSMutableSet *set = [NSMutableSet set];
    for (ChangeAccount *acc in resultArray) {
        [set addObject:acc.changeAccountById];
    }
    
    for (Account *acc in accFull){
        
        if ([set containsObject:acc.accountId]) {
            [array addObject:acc];
        }
        
    }
    
    return array;
    
}*/
/////
#pragma mark - Get Save All Accounts
-(void) getAndSaveAllAccounts:(void(^)(void)) success{
    
    [[EVAServerManager sharedManager] loginUserAndGetAccountsSuccess:^(NSMutableArray* arrayOfObject) {

        for (EVAAccountFromServer *accountServer in arrayOfObject) {

            Account *addAccount;
            
            if (![[self allAccountsByParam:@"accountId"] containsObject:accountServer.accountIdS]) {
                
                addAccount = [Account MR_createEntity];
                addAccount.name = accountServer.nameS;
                addAccount.phone = accountServer.phoneS;
                addAccount.website = accountServer.websiteS;
                addAccount.accountId = accountServer.accountIdS;
                
            }else{
                
                addAccount = [self getByPredicateWithParam:accountServer.accountIdS];

                if (![[self allAccountsByParam:@"phone"] containsObject:accountServer.accountIdS]){
                    
                    addAccount.phone = accountServer.phoneS;
                    
                }else if (![[self allAccountsByParam:@"website"] containsObject:accountServer.accountIdS]){
                    
                    addAccount.website = accountServer.websiteS;
                    
                }else if (![[self allAccountsByParam:@"name"] containsObject:accountServer.accountIdS]){
                    
                    addAccount.name = accountServer.nameS;
                    
                }
                
            }
            
        }

        [self createChangeAccountsInData];
        [self saveContext];

        success();
        
    }];
}

#pragma mark - Utility Methods
-(NSMutableSet*)allAccountsByParam:(NSString*) param {
    

    NSArray *resultArray = [Account MR_findAll];
    
    NSMutableSet *set = [NSMutableSet set];
    
    for (Account *acc in resultArray) {
        if ([acc valueForKey:param] == nil) {
            [set addObject:@""];
        }else{
            [set addObject:[acc valueForKey:param]];
        }
    }
    
    return set;

}

-(Account*) getByPredicateWithParam:(NSString*) param{
    
    NSArray *arrResult = [Account MR_findByAttribute:@"accountId" withValue:param];
    
    Account *acc = [arrResult firstObject];
    
    return acc;
    
}

#pragma mark - Synchronize With Server
-(void) synchronizedWithServerSuccess:(void(^)(void)) success{
    
    [self deleteAccountsFromServer];
    [self createAccountsAndSentToServer];
    [self changeObjectAccountInServer];
    
    [self getAndSaveAllAccounts:^{
        [self saveContext];
        success();
    }];

}

/*
 _______извлечение_______
 
 // Query to find all the persons store into the database_______
 NSArray *persons = [Person MR_findAll];
 
 // Query to find all the persons store into the database order by their 'firstname'_______
 NSArray *personsSorted = [Person MR_findAllSortedBy:@"firstname" ascending:YES];
 
 // Query to find all the persons store into the database which have 25 years old_______
 NSArray *personsWhoHave22 = [Person MR_findByAttribute:@"age" withValue:[NSNumber numberWithInt:25]];
 
 // Query to find the first person store into the databe_______
 Person *person = [Person MR_findFirst];
 
 _______апдейт_______
 
 - (void)updateAge:(NSNumber *)newAge ofPersonWithFirstname:(NSString *)firstname lastname:(NSString *)lastname {
 // Get the local context_______
 NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
 
 // Build the predicate to find the person sought_______
 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstname ==[c] %@ AND lastname ==[c] %@", firstname, lastname];
 Person *personFounded  = [Person MR_findFirstWithPredicate:predicate inContext:localContext];
 
 // If a person was founded_______
 if (personFounded) {
 // Update its age_______
 personFounded.age   = newAge;
 
 // Save the modification in the local context_______
 // With MagicalRecords 2.0.8 or newer you should use the MR_saveNestedContexts
 [localContext MR_save];
 }
 }
 
 _______удаление_______
 
 - (void)deleteFirstPersonWithFirstname:(NSString *)firstname {
 // Get the local context
 NSManagedObjectContext *localContext= [NSManagedObjectContext MR_contextForCurrentThread];
 
 // Retrieve the first person who have the given firstname
 Person *personFounded = [Person MR_findFirstByAttribute:@"firstname" withValue:firstname inContext:localContext];
 
 if (personFounded) {
 // Delete the person found
 [personFounded MR_deleteInContext:localContext];
 
 // Save the modification in the local context_______
 // With MagicalRecords 2.0.8 or newer you should use the MR_saveNestedContexts
 [localContext MR_save];
 }
 }
 
 
 */
@end
