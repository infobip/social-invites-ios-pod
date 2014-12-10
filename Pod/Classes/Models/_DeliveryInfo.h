// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DeliveryInfo.h instead.

#import <CoreData/CoreData.h>


extern const struct DeliveryInfoAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *clientCorrelator;
	__unsafe_unretained NSString *deliveryStatus;
	__unsafe_unretained NSString *messageId;
	__unsafe_unretained NSString *personId;
	__unsafe_unretained NSString *price;
} DeliveryInfoAttributes;

extern const struct DeliveryInfoRelationships {
	__unsafe_unretained NSString *socialInviteDelivery;
} DeliveryInfoRelationships;

extern const struct DeliveryInfoFetchedProperties {
} DeliveryInfoFetchedProperties;

@class SocialInviteDelivery;








@interface DeliveryInfoID : NSManagedObjectID {}
@end

@interface _DeliveryInfo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DeliveryInfoID*)objectID;





@property (nonatomic, strong) NSString* address;



//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* clientCorrelator;



//- (BOOL)validateClientCorrelator:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* deliveryStatus;



//- (BOOL)validateDeliveryStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* messageId;



//- (BOOL)validateMessageId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* personId;



@property int32_t personIdValue;
- (int32_t)personIdValue;
- (void)setPersonIdValue:(int32_t)value_;

//- (BOOL)validatePersonId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property double priceValue;
- (double)priceValue;
- (void)setPriceValue:(double)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SocialInviteDelivery *socialInviteDelivery;

//- (BOOL)validateSocialInviteDelivery:(id*)value_ error:(NSError**)error_;





@end

@interface _DeliveryInfo (CoreDataGeneratedAccessors)

@end

@interface _DeliveryInfo (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;




- (NSString*)primitiveClientCorrelator;
- (void)setPrimitiveClientCorrelator:(NSString*)value;




- (NSString*)primitiveDeliveryStatus;
- (void)setPrimitiveDeliveryStatus:(NSString*)value;




- (NSString*)primitiveMessageId;
- (void)setPrimitiveMessageId:(NSString*)value;




- (NSNumber*)primitivePersonId;
- (void)setPrimitivePersonId:(NSNumber*)value;

- (int32_t)primitivePersonIdValue;
- (void)setPrimitivePersonIdValue:(int32_t)value_;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (double)primitivePriceValue;
- (void)setPrimitivePriceValue:(double)value_;





- (SocialInviteDelivery*)primitiveSocialInviteDelivery;
- (void)setPrimitiveSocialInviteDelivery:(SocialInviteDelivery*)value;


@end
