//
//  ChangeAccount+CoreDataProperties.m
//  
//
//  Created by ctuser on 12/1/17.
//
//

#import "ChangeAccount+CoreDataProperties.h"

@implementation ChangeAccount (CoreDataProperties)

+ (NSFetchRequest<ChangeAccount *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ChangeAccount"];
}

@dynamic changeAccountById;
@dynamic changedValuesByKey;
@dynamic changesValuesSet;
@dynamic isChange;
@dynamic isDelete;

@end
