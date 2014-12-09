// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SendSmsResponse.h instead.

#import <CoreData/CoreData.h>


extern const struct SendSmsResponseAttributes {
	__unsafe_unretained NSString *bulkId;
	__unsafe_unretained NSString *deliveryInfoUrl;
} SendSmsResponseAttributes;

extern const struct SendSmsResponseRelationships {
	__unsafe_unretained NSString *responses;
} SendSmsResponseRelationships;

extern const struct SendSmsResponseFetchedProperties {
} SendSmsResponseFetchedProperties;

@class SmsMessageResponse;




@interface SendSmsResponseID : NSManagedObjectID {}
@end

@interface _SendSmsResponse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SendSmsResponseID*)objectID;





@property (nonatomic, strong) NSString* bulkId;



//- (BOOL)validateBulkId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* deliveryInfoUrl;



//- (BOOL)validateDeliveryInfoUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *responses;

- (NSMutableSet*)responsesSet;





@end

@interface _SendSmsResponse (CoreDataGeneratedAccessors)

- (void)addResponses:(NSSet*)value_;
- (void)removeResponses:(NSSet*)value_;
- (void)addResponsesObject:(SmsMessageResponse*)value_;
- (void)removeResponsesObject:(SmsMessageResponse*)value_;

@end

@interface _SendSmsResponse (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBulkId;
- (void)setPrimitiveBulkId:(NSString*)value;




- (NSString*)primitiveDeliveryInfoUrl;
- (void)setPrimitiveDeliveryInfoUrl:(NSString*)value;





- (NSMutableSet*)primitiveResponses;
- (void)setPrimitiveResponses:(NSMutableSet*)value;


@end
