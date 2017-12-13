//
//  EVAServerManager.m
//  TestSalesForce
//
//  Created by ctuser on 11/20/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import "EVAServerManager.h"
#import "EVADataManager.h"

#import "zkSforceClient.h"
#import "zkSforce.h"
#import "Account+CoreDataClass.h"
#import "EVAAccountFromServer.h"

@interface EVAServerManager ()

@property (strong, nonatomic) ZKSforceClient *client;
@property (strong, nonatomic) ZKQueryResult *result;

@end

static NSString* kUserName = @"viktor.yekhlakov@ctdev.io";
static NSString* kPassword = @"Rjunbnbuhf960R9NYooVp1320x7yEi221WyJ3";

@implementation EVAServerManager

@synthesize client = _client;

+(EVAServerManager*) sharedManager {
    static EVAServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EVAServerManager alloc] init];
    });
    return manager;
}

-(ZKSforceClient*) client{
    
    if (_client != nil) {
        return _client;
    }
    
    _client = [[ZKSforceClient alloc] init];
    [_client login:kUserName password:kPassword];
    
    return _client;
}

-(void) loginUserAndGetAccountsSuccess:(void(^)(NSMutableArray* arrayOfObject)) success{
    
    /*NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"Ira" forKey:@"name"];
    [userDefaults objectForKey:@"name"]*/
    
    /*NSString *lastModify = [NSUserDefaults valueForKey:@"modify"];
    if (lastModify == nil) {
        lastModify = @"";
    }*/
    
    @try {
        //ZKSforceClient *client = [[ZKSforceClient alloc] init];
        //[client login:kUserName password:kPassword];
        
        NSDate *dateSync = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
        
        NSString *query;
        
        if (dateSync) {
            query = [NSString stringWithFormat:@"SELECT id,name,Phone,Website, LastModifiedDate FROM Account WHERE LastModifiedDate > %@", dateSync];
        } else {
            query = @"SELECT LastModifiedDate,id,name,Phone,Website from account order by SystemModstamp desc LIMIT 50";
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
            ZKQueryResult *qr = [self.client query:query];
            //self.client = client;
            self.result = qr;
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (ZKSObject *object in qr.records){
                EVAAccountFromServer *account = [[EVAAccountFromServer alloc] initWithObject:object];
                [array addObject:account];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                success(array);
            });
        });
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    
}

-(void) updateValueInAccount:(Account*) account andDictChangedValues:(NSDictionary*) dict{
    
    @try {
        
        ZKSObject *updateAccount = [ZKSObject withType:@"Account"];
        [updateAccount setId:account.accountId];
        
        for (NSString *key in dict.allKeys){
            
            NSString *value = [dict valueForKey:key];
            [updateAccount setFieldValue:value field:key.capitalizedString];
            
        }
        
        NSArray *results = [self.client update:[NSArray arrayWithObject:updateAccount]];
        ZKSaveResult *sr = [results objectAtIndex:0];
        if ([sr success]){
            NSLog(@"update contact id %@", [sr id]);
        }else{
            NSLog(@"error creating contact %@ %@", [sr statusCode], [sr message]);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    
}

-(void) createNewAccount:(Account*) account success:(void(^)(void)) success{

    @try {
        
        ZKSObject *newAccount = [ZKSObject withType:@"Account"];
        
        [newAccount setFieldValue:account.name field:@"Name"];
        [newAccount setFieldValue:account.phone field:@"Phone"];
        [newAccount setFieldValue:account.website field:@"Website"];
        
        NSArray *results = [self.client create:[NSArray arrayWithObject:newAccount]];
        ZKSaveResult *sr = [results objectAtIndex:0];
        if ([sr success]){
            NSLog(@"new contact id %@", [sr id]);
            success();
        }else{
            NSLog(@"error creating contact %@ %@", [sr statusCode], [sr message]);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    
}

-(void) deleteAccount:(Account*) account{
    
    @try{
        
        NSArray *results = [self.client delete:[NSArray arrayWithObject:account.accountId]];
        ZKSaveResult *sr = [results objectAtIndex:0];
        if ([sr success]){
            NSLog(@"delete contact id %@", [sr id]);
        }else{
            NSLog(@"error delete contact %@ %@", [sr statusCode], [sr message]);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    
}
@end
