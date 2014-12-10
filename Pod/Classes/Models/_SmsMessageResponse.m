// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SmsMessageResponse.m instead.

#import "_SmsMessageResponse.h"

const struct SmsMessageResponseAttributes SmsMessageResponseAttributes = {
	.messageId = @"messageId",
	.price = @"price",
	.status = @"status",
};

const struct SmsMessageResponseRelationships SmsMessageResponseRelationships = {
	.smsSendResponse = @"smsSendResponse",
};

const struct SmsMessageResponseFetchedProperties SmsMessageResponseFetchedProperties = {
};

@implementation SmsMessageResponseID
@end

@implementation _SmsMessageResponse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SmsMessageResponse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SmsMessageResponse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SmsMessageResponse" inManagedObjectContext:moc_];
}

- (SmsMessageResponseID*)objectID {
	return (SmsMessageResponseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic messageId;






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





@dynamic status;






@dynamic smsSendResponse;

	






@end
