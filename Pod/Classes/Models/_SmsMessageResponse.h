// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SmsMessageResponse.h instead.

#import <CoreData/CoreData.h>


extern const struct SmsMessageResponseAttributes {
	__unsafe_unretained NSString *messageId;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *status;
} SmsMessageResponseAttributes;

extern const struct SmsMessageResponseRelationships {
	__unsafe_unretained NSString *smsSendResponse;
} SmsMessageResponseRelationships;

extern const struct SmsMessageResponseFetchedProperties {
} SmsMessageResponseFetchedProperties;

@class SendSmsResponse;





@interface SmsMessageResponseID : NSManagedObjectID {}
@end

@interface _SmsMessageResponse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SmsMessageResponseID*)objectID;





@property (nonatomic, strong) NSString* messageId;



//- (BOOL)validateMessageId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property double priceValue;
- (double)priceValue;
- (void)setPriceValue:(double)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* status;



//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SendSmsResponse *smsSendResponse;

//- (BOOL)validateSmsSendResponse:(id*)value_ error:(NSError**)error_;





@end

@interface _SmsMessageResponse (CoreDataGeneratedAccessors)

@end

@interface _SmsMessageResponse (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveMessageId;
- (void)setPrimitiveMessageId:(NSString*)value;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (double)primitivePriceValue;
- (void)setPrimitivePriceValue:(double)value_;




- (NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(NSString*)value;





- (SendSmsResponse*)primitiveSmsSendResponse;
- (void)setPrimitiveSmsSendResponse:(SendSmsResponse*)value;


@end
