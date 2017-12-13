//
//  EVADataManager.h
//  TestSalesForce
//
//  Created by ctuser on 11/22/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+ShorthandMethods.h>

@class Account;

@interface EVADataManager : NSObject


 @property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+(EVADataManager*) sharedManager;
- (void)saveContext;
- (NSManagedObjectContext *)managedObjectContext;

-(void) addChangeValuesToChangeAccount:(Account*) account;
-(void) deleteAccount:(Account*) account success:(void(^)(void)) success;
-(void) createAccountInCD:(NSDictionary*) dict success:(void(^)(void)) success;

-(void) getAndSaveAllAccounts:(void(^)(void)) success;

-(void) updateValue:(NSString*) value inProperty:(NSString*) property inAccount:(Account*) account;

-(void) synchronizedWithServerSuccess:(void(^)(void)) success;
@end
