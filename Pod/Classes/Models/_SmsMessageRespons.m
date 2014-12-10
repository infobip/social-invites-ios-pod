// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SmsMessageRespons.m instead.

#import "_SmsMessageRespons.h"

const struct SmsMessageResponsAttributes SmsMessageResponsAttributes = {
        .messageId = @"messageId",
        .price = @"price",
        .status = @"status",
};

const struct SmsMessageResponsRelationships SmsMessageResponsRelationships = {
        .smsSendResponse = @"smsSendResponse",
};

const struct SmsMessageResponsFetchedProperties SmsMessageResponsFetchedProperties = {
};

@implementation SmsMessageResponsID
@end

@implementation _SmsMessageRespons

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"SmsMessageRespons" inManagedObjectContext:moc_];
}

+ (NSString *)entityName {
    return @"SmsMessageRespons";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_ {
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"SmsMessageRespons" inManagedObjectContext:moc_];
}

- (SmsMessageResponsID *)objectID {
    return (SmsMessageResponsID *) [super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
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
