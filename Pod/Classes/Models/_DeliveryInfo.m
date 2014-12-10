// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DeliveryInfo.m instead.

#import "_DeliveryInfo.h"

const struct DeliveryInfoAttributes DeliveryInfoAttributes = {
	.address = @"address",
	.clientCorrelator = @"clientCorrelator",
	.deliveryStatus = @"deliveryStatus",
	.messageId = @"messageId",
	.personId = @"personId",
	.price = @"price",
};

const struct DeliveryInfoRelationships DeliveryInfoRelationships = {
	.socialInviteDelivery = @"socialInviteDelivery",
};

const struct DeliveryInfoFetchedProperties DeliveryInfoFetchedProperties = {
};

@implementation DeliveryInfoID
@end

@implementation _DeliveryInfo

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DeliveryInfo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DeliveryInfo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DeliveryInfo" inManagedObjectContext:moc_];
}

- (DeliveryInfoID*)objectID {
	return (DeliveryInfoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"personIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"personId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic address;






@dynamic clientCorrelator;






@dynamic deliveryStatus;






@dynamic messageId;






@dynamic personId;



- (int32_t)personIdValue {
	NSNumber *result = [self personId];
	return [result intValue];
}

- (void)setPersonIdValue:(int32_t)value_ {
	[self setPersonId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePersonIdValue {
	NSNumber *result = [self primitivePersonId];
	return [result intValue];
}

- (void)setPrimitivePersonIdValue:(int32_t)value_ {
	[self setPrimitivePersonId:[NSNumber numberWithInt:value_]];
}





@dynamic price;



- (double)priceValue {
	NSNumber *result = [self price];
	return [result doubleValue];
}

- (void)setPriceValue:(double)value_ {
	[self setPrice:[NSNumber numberWithDouble:value_]];
}

- (double)primitivePriceValue {
	NSNumber *result = [self primitivePrice];
	return [result doubleValue];
}

- (void)setPrimitivePriceValue:(double)value_ {
	[self setPrimitivePrice:[NSNumber numberWithDouble:value_]];
}





@dynamic socialInviteDelivery;

	






@end
