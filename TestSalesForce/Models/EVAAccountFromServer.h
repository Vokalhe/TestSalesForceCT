//
//  EVAAccountFromServer.h
//  TestSalesForce
//
//  Created by ctuser on 11/22/17.
//  Copyright © 2017 ctuser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZKSObject;

@interface EVAAccountFromServer : NSObject

@property (strong, nonatomic) NSString *nameS;
@property (strong, nonatomic) NSString *phoneS;
@property (strong, nonatomic) NSString *websiteS;
@property (strong, nonatomic) NSString *accountIdS;
@property (strong, nonatomic) NSDate *dateModify;

- (instancetype)initWithObject:(ZKSObject*) object;

@end
