//
//  ChangeAccount+CoreDataProperties.h
//  
//
//  Created by ctuser on 12/1/17.
//
//

#import "ChangeAccount+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChangeAccount (CoreDataProperties)

+ (NSFetchRequest<ChangeAccount *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *changeAccountById;
@property (nullable, nonatomic, retain) NSObject *changedValuesByKey;
@property (nullable, nonatomic, retain) NSObject *changesValuesSet;
@property (nonatomic) BOOL isChange;
@property (nonatomic) BOOL isDelete;

@end

NS_ASSUME_NONNULL_END
