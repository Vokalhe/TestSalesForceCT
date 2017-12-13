// Copyright (c) 2006,2012 Simon Fell
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE.
//
// 
// Note: This file was generated by WSDL2ZKSforce. 
//		  see https://github.com/superfell/WSDL2ZKSforce
//       DO NOT HAND EDIT.
//

#import "ZKDescribeField.h"
#import "ZKDescribeSObject.h"
#import "zkParser.h"
#import "ZKFilteredLookupInfo.h"
#import "ZKPicklistEntry.h"
#import "ZKXsdAnyType.h"

@implementation ZKDescribeField

@synthesize sobject;

-(id)copyWithZone:(NSZone *)zone {
    zkElement *e = [[node copyWithZone:zone] autorelease];
    ZKDescribeField *c = [[ZKDescribeField alloc] initWithXmlElement:e];
    c.sobject = self.sobject;
    return c;
}

-(zkElement *)node {
	return node;
}

-(BOOL)isEqual:(id)anObject {
	if (![anObject isKindOfClass:[ZKDescribeField class]]) return NO;
	return [node isEqual:[anObject node]];
}

-(NSUInteger)hash {
	return [node hash];
}

-(BOOL)aggregatable {
    return [self boolean:@"aggregatable"];
}
			
-(BOOL)autoNumber {
    return [self boolean:@"autoNumber"];
}
			
-(NSInteger)byteLength {
    return [self integer:@"byteLength"];
}
			
-(BOOL)calculated {
    return [self boolean:@"calculated"];
}
			
-(NSString *)calculatedFormula {
    return [self string:@"calculatedFormula"];
}
			
-(BOOL)cascadeDelete {
    return [self boolean:@"cascadeDelete"];
}
			
-(BOOL)caseSensitive {
    return [self boolean:@"caseSensitive"];
}
			
-(NSString *)compoundFieldName {
    return [self string:@"compoundFieldName"];
}
			
-(NSString *)controllerName {
    return [self string:@"controllerName"];
}
			
-(BOOL)createable {
    return [self boolean:@"createable"];
}
			
-(BOOL)custom {
    return [self boolean:@"custom"];
}
			
-(ZKXsdAnyType *)defaultValue {
    return [self anyType:@"defaultValue"];
}
			
-(NSString *)defaultValueFormula {
    return [self string:@"defaultValueFormula"];
}
			
-(BOOL)defaultedOnCreate {
    return [self boolean:@"defaultedOnCreate"];
}
			
-(BOOL)dependentPicklist {
    return [self boolean:@"dependentPicklist"];
}
			
-(BOOL)deprecatedAndHidden {
    return [self boolean:@"deprecatedAndHidden"];
}
			
-(NSInteger)digits {
    return [self integer:@"digits"];
}
			
-(BOOL)displayLocationInDecimal {
    return [self boolean:@"displayLocationInDecimal"];
}
			
-(BOOL)encrypted {
    return [self boolean:@"encrypted"];
}
			
-(BOOL)externalId {
    return [self boolean:@"externalId"];
}
			
-(NSString *)extraTypeInfo {
    return [self string:@"extraTypeInfo"];
}
			
-(BOOL)filterable {
    return [self boolean:@"filterable"];
}
			
-(ZKFilteredLookupInfo *)filteredLookupInfo {
    return [[self complexTypeArrayFromElements:@"filteredLookupInfo" cls:[ZKFilteredLookupInfo class]] lastObject];
}
			
-(BOOL)groupable {
    return [self boolean:@"groupable"];
}
			
-(BOOL)highScaleNumber {
    return [self boolean:@"highScaleNumber"];
}
			
-(BOOL)htmlFormatted {
    return [self boolean:@"htmlFormatted"];
}
			
-(BOOL)idLookup {
    return [self boolean:@"idLookup"];
}
			
-(NSString *)inlineHelpText {
    return [self string:@"inlineHelpText"];
}
			
-(NSString *)label {
    return [self string:@"label"];
}
			
-(NSInteger)length {
    return [self integer:@"length"];
}
			
-(NSString *)mask {
    return [self string:@"mask"];
}
			
-(NSString *)maskType {
    return [self string:@"maskType"];
}
			
-(NSString *)name {
    return [self string:@"name"];
}
			
-(BOOL)nameField {
    return [self boolean:@"nameField"];
}
			
-(BOOL)namePointing {
    return [self boolean:@"namePointing"];
}
			
-(BOOL)nillable {
    return [self boolean:@"nillable"];
}
			
-(BOOL)permissionable {
    return [self boolean:@"permissionable"];
}
			
-(NSArray *)picklistValues {
    return [self complexTypeArrayFromElements:@"picklistValues" cls:[ZKPicklistEntry class]];
}
			
-(NSInteger)precision {
    return [self integer:@"precision"];
}
			
-(BOOL)queryByDistance {
    return [self boolean:@"queryByDistance"];
}
			
-(NSString *)referenceTargetField {
    return [self string:@"referenceTargetField"];
}
			
-(NSArray *)referenceTo {
    return [self strings:@"referenceTo"];
}
			
-(NSString *)relationshipName {
    return [self string:@"relationshipName"];
}
			
-(NSInteger)relationshipOrder {
    return [self integer:@"relationshipOrder"];
}
			
-(BOOL)restrictedDelete {
    return [self boolean:@"restrictedDelete"];
}
			
-(BOOL)restrictedPicklist {
    return [self boolean:@"restrictedPicklist"];
}
			
-(NSInteger)scale {
    return [self integer:@"scale"];
}
			
-(NSString *)soapType {
    return [self string:@"soapType"];
}
			
-(BOOL)sortable {
    return [self boolean:@"sortable"];
}
			
-(NSString *)type {
    return [self string:@"type"];
}
			
-(BOOL)unique {
    return [self boolean:@"unique"];
}
			
-(BOOL)updateable {
    return [self boolean:@"updateable"];
}
			
-(BOOL)writeRequiresMasterRead {
    return [self boolean:@"writeRequiresMasterRead"];
}
			
@end
