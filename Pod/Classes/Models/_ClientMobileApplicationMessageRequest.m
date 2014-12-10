// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ClientMobileApplicationMessageRequest.m instead.

#import "_ClientMobileApplicationMessageRequest.h"

const struct ClientMobileApplicationMessageRequestAttributes ClientMobileApplicationMessageRequestAttributes = {
	.clientPlaceholder = @"clientPlaceholder",
	.placeholder = @"placeholder",
	.text = @"text",
};

const struct ClientMobileApplicationMessageRequestRelationships ClientMobileApplicationMessageRequestRelationships = {
};

const struct ClientMobileApplicationMessageRequestFetchedProperties ClientMobileApplicationMessageRequestFetchedProperties = {
};

@implementation ClientMobileApplicationMessageRequestID
@end

@implementation _ClientMobileApplicationMessageRequest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ClientMobileApplicationMessageRequest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ClientMobileApplicationMessageRequest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ClientMobileApplicationMessageRequest" inManagedObjectContext:moc_];
}

- (ClientMobileApplicationMessageRequestID*)objectID {
	return (ClientMobileApplicationMessageRequestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic clientPlaceholder;






@dynamic placeholder;






@dynamic text;











@end
