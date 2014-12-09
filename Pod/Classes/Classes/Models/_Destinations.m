// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Destinations.m instead.

#import "_Destinations.h"

const struct DestinationsAttributes DestinationsAttributes = {
	.address = @"address",
	.clientData = @"clientData",
	.messageId = @"messageId",
};

const struct DestinationsRelationships DestinationsRelationships = {
	.recipients = @"recipients",
};

const struct DestinationsFetchedProperties DestinationsFetchedProperties = {
};

@implementation DestinationsID
@end

@implementation _Destinations

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Destinations" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Destinations";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Destinations" inManagedObjectContext:moc_];
}

- (DestinationsID*)objectID {
	return (DestinationsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic address;






@dynamic clientData;






@dynamic messageId;






@dynamic recipients;

	






@end
