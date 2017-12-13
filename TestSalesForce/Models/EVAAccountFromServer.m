//
//  EVAAccountFromServer.m
//  TestSalesForce
//
//  Created by ctuser on 11/22/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import "EVAAccountFromServer.h"
#import "zkSforce.h"

@implementation EVAAccountFromServer

- (instancetype)initWithObject:(ZKSObject*) object
{
    self = [super init];
    if (self) {
        self.nameS = [object fieldValue:@"Name"];
        self.phoneS = [object fieldValue:@"Phone"];
        self.websiteS = [object fieldValue:@"Website"];
        self.accountIdS = [object fieldValue:@"Id"];
        self.dateModify = [object fieldValue:@"LastModifiedDate"];
    }
    return self;
}

@end
