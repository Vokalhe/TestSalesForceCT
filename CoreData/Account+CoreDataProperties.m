//
//  Account+CoreDataProperties.m
//  
//
//  Created by ctuser on 11/27/17.
//
//

#import "Account+CoreDataProperties.h"

@implementation Account (CoreDataProperties)

+ (NSFetchRequest<Account *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Account"];
}

@dynamic accountId;
@dynamic name;
@dynamic phone;
@dynamic website;



@end
