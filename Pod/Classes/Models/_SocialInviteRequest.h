// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SocialInviteRequest.h instead.

#import <CoreData/CoreData.h>


extern const struct SocialInviteRequestAttributes {
	__unsafe_unretained NSString *messageKey;
	__unsafe_unretained NSString *sender;
} SocialInviteRequestAttributes;

extern const struct SocialInviteRequestRelationships {
	__unsafe_unretained NSString *recipients;
} SocialInviteRequestRelationships;

extern const struct SocialInviteRequestFetchedProperties {
} SocialInviteRequestFetchedProperties;

@class Recipient;




@interface SocialInviteRequestID : NSManagedObjectID {}
@end

@interface _SocialInviteRequest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SocialInviteRequestID*)objectID;





@property (nonatomic, strong) NSString* messageKey;



//- (BOOL)validateMessageKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sender;



//- (BOOL)validateSender:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Recipient *recipients;

//- (BOOL)validateRecipients:(id*)value_ error:(NSError**)error_;





@end

@interface _SocialInviteRequest (CoreDataGeneratedAccessors)

@end

@interface _SocialInviteRequest (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveMessageKey;
- (void)setPrimitiveMessageKey:(NSString*)value;




- (NSString*)primitiveSender;
- (void)setPrimitiveSender:(NSString*)value;





- (Recipient*)primitiveRecipients;
- (void)setPrimitiveRecipients:(Recipient*)value;


@end
