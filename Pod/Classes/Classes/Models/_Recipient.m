// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.m instead.

#import "_Recipient.h"

const struct RecipientAttributes RecipientAttributes = {
};

const struct RecipientRelationships RecipientRelationships = {
	.destinations = @"destinations",
	.request = @"request",
};

const struct RecipientFetchedProperties RecipientFetchedProperties = {
};

@implementation RecipientID
@end

@implementation _Recipient

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Recipient" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Recipient";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Recipient" inManagedObjectContext:moc_];
}

- (RecipientID*)objectID {
	return (RecipientID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic destinations;

	
- (NSMutableSet*)destinationsSet {
	[self willAccessValueForKey:@"destinations"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"destinations"];
  
	[self didAccessValueForKey:@"destinations"];
	return result;
}
	

@dynamic request;

	






@end
