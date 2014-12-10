// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Destinations.h instead.

#import <CoreData/CoreData.h>


extern const struct DestinationsAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *clientData;
	__unsafe_unretained NSString *messageId;
} DestinationsAttributes;

extern const struct DestinationsRelationships {
	__unsafe_unretained NSString *recipients;
} DestinationsRelationships;

extern const struct DestinationsFetchedProperties {
} DestinationsFetchedProperties;

@class Recipient;


@class NSObject;


@interface DestinationsID : NSManagedObjectID {}
@end

@interface _Destinations : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DestinationsID*)objectID;





@property (nonatomic, strong) NSString* address;



//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id clientData;



//- (BOOL)validateClientData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* messageId;



//- (BOOL)validateMessageId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Recipient *recipients;

//- (BOOL)validateRecipients:(id*)value_ error:(NSError**)error_;





@end

@interface _Destinations (CoreDataGeneratedAccessors)

@end

@interface _Destinations (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;




- (id)primitiveClientData;
- (void)setPrimitiveClientData:(id)value;




- (NSString*)primitiveMessageId;
- (void)setPrimitiveMessageId:(NSString*)value;





- (Recipient*)primitiveRecipients;
- (void)setPrimitiveRecipients:(Recipient*)value;


@end
