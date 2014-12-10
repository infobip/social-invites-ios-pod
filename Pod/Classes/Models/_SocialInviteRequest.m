// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SocialInviteRequest.m instead.

#import "_SocialInviteRequest.h"

const struct SocialInviteRequestAttributes SocialInviteRequestAttributes = {
	.messageKey = @"messageKey",
	.sender = @"sender",
};

const struct SocialInviteRequestRelationships SocialInviteRequestRelationships = {
	.recipients = @"recipients",
};

const struct SocialInviteRequestFetchedProperties SocialInviteRequestFetchedProperties = {
};

@implementation SocialInviteRequestID
@end

@implementation _SocialInviteRequest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SocialInviteRequest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SocialInviteRequest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SocialInviteRequest" inManagedObjectContext:moc_];
}

- (SocialInviteRequestID*)objectID {
	return (SocialInviteRequestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic messageKey;






@dynamic sender;






@dynamic recipients;

	






@end
