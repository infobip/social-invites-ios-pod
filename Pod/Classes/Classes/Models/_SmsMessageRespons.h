// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SmsMessageRespons.h instead.

#import <CoreData/CoreData.h>


extern const struct SmsMessageResponsAttributes {
    __unsafe_unretained NSString *messageId;
    __unsafe_unretained NSString *price;
    __unsafe_unretained NSString *status;
} SmsMessageResponsAttributes;

extern const struct SmsMessageResponsRelationships {
    __unsafe_unretained NSString *smsSendResponse;
} SmsMessageResponsRelationships;

extern const struct SmsMessageResponsFetchedProperties {
} SmsMessageResponsFetchedProperties;

@class SendSmsResponse;


@interface SmsMessageResponsID : NSManagedObjectID {
}
@end

@interface _SmsMessageRespons : NSManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (SmsMessageResponsID *)objectID;


@property(nonatomic, strong) NSString *messageId;



//- (BOOL)validateMessageId:(id*)value_ error:(NSError**)error_;





@property(nonatomic, strong) NSNumber *price;


@property double priceValue;

- (double)priceValue;

- (void)setPriceValue:(double)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property(nonatomic, strong) NSString *status;



//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property(nonatomic, strong) SendSmsResponse *smsSendResponse;

//- (BOOL)validateSmsSendResponse:(id*)value_ error:(NSError**)error_;





@end

@interface _SmsMessageRespons (CoreDataGeneratedAccessors)

@end

@interface _SmsMessageRespons (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveMessageId;

- (void)setPrimitiveMessageId:(NSString *)value;


- (NSNumber *)primitivePrice;

- (void)setPrimitivePrice:(NSNumber *)value;

- (double)primitivePriceValue;

- (void)setPrimitivePriceValue:(double)value_;


- (NSString *)primitiveStatus;

- (void)setPrimitiveStatus:(NSString *)value;


- (SendSmsResponse *)primitiveSmsSendResponse;

- (void)setPrimitiveSmsSendResponse:(SendSmsResponse *)value;


@end
