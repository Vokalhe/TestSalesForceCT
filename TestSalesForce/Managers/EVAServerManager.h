//
//  EVAServerManager.h
//  TestSalesForce
//
//  Created by ctuser on 11/20/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZKQueryResult, ZKSObject, Account;

@interface EVAServerManager : NSObject
+(EVAServerManager*) sharedManager;

-(void) loginUserAndGetAccountsSuccess:(void(^)(NSMutableArray* arrayOfObject)) success;
-(void) updateValueInAccount:(Account*) account andDictChangedValues:(NSDictionary*) dict;
-(void) createNewAccount:(Account*) account success:(void(^)(void)) success;
-(void) deleteAccount:(Account*) account;

@end
