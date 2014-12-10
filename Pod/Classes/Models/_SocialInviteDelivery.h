// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SocialInviteDelivery.h instead.

#import <CoreData/CoreData.h>


extern const struct SocialInviteDeliveryAttributes {
	__unsafe_unretained NSString *resourceURL;
} SocialInviteDeliveryAttributes;

extern const struct SocialInviteDeliveryRelationships {
	__unsafe_unretained NSString *deliveryInfo;
} SocialInviteDeliveryRelationships;

extern const struct SocialInviteDeliveryFetchedProperties {
} SocialInviteDeliveryFetchedProperties;

@class DeliveryInfo;



@interface SocialInviteDeliveryID : NSManagedObjectID {}
@end

@interface _SocialInviteDelivery : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SocialInviteDeliveryID*)objectID;





@property (nonatomic, strong) NSString* resourceURL;



//- (BOOL)validateResourceURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *deliveryInfo;

- (NSMutableSet*)deliveryInfoSet;





@end

@interface _SocialInviteDelivery (CoreDataGeneratedAccessors)

- (void)addDeliveryInfo:(NSSet*)value_;
- (void)removeDeliveryInfo:(NSSet*)value_;
- (void)addDeliveryInfoObject:(DeliveryInfo*)value_;
- (void)removeDeliveryInfoObject:(DeliveryInfo*)value_;

@end

@interface _SocialInviteDelivery (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveResourceURL;
- (void)setPrimitiveResourceURL:(NSString*)value;





- (NSMutableSet*)primitiveDeliveryInfo;
- (void)setPrimitiveDeliveryInfo:(NSMutableSet*)value;


@end
