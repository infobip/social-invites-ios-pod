// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.h instead.

#import <CoreData/CoreData.h>


extern const struct RecipientAttributes {
} RecipientAttributes;

extern const struct RecipientRelationships {
	__unsafe_unretained NSString *destinations;
	__unsafe_unretained NSString *request;
} RecipientRelationships;

extern const struct RecipientFetchedProperties {
} RecipientFetchedProperties;

@class Destinations;
@class SocialInviteRequest;


@interface RecipientID : NSManagedObjectID {}
@end

@interface _Recipient : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecipientID*)objectID;





@property (nonatomic, strong) NSSet *destinations;

- (NSMutableSet*)destinationsSet;




@property (nonatomic, strong) SocialInviteRequest *request;

//- (BOOL)validateRequest:(id*)value_ error:(NSError**)error_;





@end

@interface _Recipient (CoreDataGeneratedAccessors)

- (void)addDestinations:(NSSet*)value_;
- (void)removeDestinations:(NSSet*)value_;
- (void)addDestinationsObject:(Destinations*)value_;
- (void)removeDestinationsObject:(Destinations*)value_;

@end

@interface _Recipient (CoreDataGeneratedPrimitiveAccessors)



- (NSMutableSet*)primitiveDestinations;
- (void)setPrimitiveDestinations:(NSMutableSet*)value;



- (SocialInviteRequest*)primitiveRequest;
- (void)setPrimitiveRequest:(SocialInviteRequest*)value;


@end
