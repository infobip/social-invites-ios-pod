// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SendSmsResponse.m instead.

#import "_SendSmsResponse.h"

const struct SendSmsResponseAttributes SendSmsResponseAttributes = {
	.bulkId = @"bulkId",
	.deliveryInfoUrl = @"deliveryInfoUrl",
};

const struct SendSmsResponseRelationships SendSmsResponseRelationships = {
	.responses = @"responses",
};

const struct SendSmsResponseFetchedProperties SendSmsResponseFetchedProperties = {
};

@implementation SendSmsResponseID
@end

@implementation _SendSmsResponse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SendSmsResponse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SendSmsResponse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SendSmsResponse" inManagedObjectContext:moc_];
}

- (SendSmsResponseID*)objectID {
	return (SendSmsResponseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic bulkId;






@dynamic deliveryInfoUrl;






@dynamic responses;

	
- (NSMutableSet*)responsesSet {
	[self willAccessValueForKey:@"responses"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"responses"];
  
	[self didAccessValueForKey:@"responses"];
	return result;
}
	






@end
