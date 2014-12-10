// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ClientMobileApplicationMessageResponse.m instead.

#import "_ClientMobileApplicationMessageResponse.h"

const struct ClientMobileApplicationMessageResponseAttributes ClientMobileApplicationMessageResponseAttributes = {
	.clientMobileApplicationKey = @"clientMobileApplicationKey",
	.clientPlaceholder = @"clientPlaceholder",
	.key = @"key",
	.placeholder = @"placeholder",
	.text = @"text",
};

const struct ClientMobileApplicationMessageResponseRelationships ClientMobileApplicationMessageResponseRelationships = {
};

const struct ClientMobileApplicationMessageResponseFetchedProperties ClientMobileApplicationMessageResponseFetchedProperties = {
};

@implementation ClientMobileApplicationMessageResponseID
@end

@implementation _ClientMobileApplicationMessageResponse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ClientMobileApplicationMessageResponse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ClientMobileApplicationMessageResponse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ClientMobileApplicationMessageResponse" inManagedObjectContext:moc_];
}

- (ClientMobileApplicationMessageResponseID*)objectID {
	return (ClientMobileApplicationMessageResponseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic clientMobileApplicationKey;






@dynamic clientPlaceholder;






@dynamic key;






@dynamic placeholder;






@dynamic text;











@end
