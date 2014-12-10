// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SocialInviteDelivery.m instead.

#import "_SocialInviteDelivery.h"

const struct SocialInviteDeliveryAttributes SocialInviteDeliveryAttributes = {
	.resourceURL = @"resourceURL",
};

const struct SocialInviteDeliveryRelationships SocialInviteDeliveryRelationships = {
	.deliveryInfo = @"deliveryInfo",
};

const struct SocialInviteDeliveryFetchedProperties SocialInviteDeliveryFetchedProperties = {
};

@implementation SocialInviteDeliveryID
@end

@implementation _SocialInviteDelivery

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SocialInviteDelivery" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SocialInviteDelivery";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SocialInviteDelivery" inManagedObjectContext:moc_];
}

- (SocialInviteDeliveryID*)objectID {
	return (SocialInviteDeliveryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic resourceURL;






@dynamic deliveryInfo;

	
- (NSMutableSet*)deliveryInfoSet {
	[self willAccessValueForKey:@"deliveryInfo"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"deliveryInfo"];
  
	[self didAccessValueForKey:@"deliveryInfo"];
	return result;
}
	






@end
