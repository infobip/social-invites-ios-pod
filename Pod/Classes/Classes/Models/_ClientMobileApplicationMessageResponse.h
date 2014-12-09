// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ClientMobileApplicationMessageResponse.h instead.

#import <CoreData/CoreData.h>


extern const struct ClientMobileApplicationMessageResponseAttributes {
	__unsafe_unretained NSString *clientMobileApplicationKey;
	__unsafe_unretained NSString *clientPlaceholder;
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *placeholder;
	__unsafe_unretained NSString *text;
} ClientMobileApplicationMessageResponseAttributes;

extern const struct ClientMobileApplicationMessageResponseRelationships {
} ClientMobileApplicationMessageResponseRelationships;

extern const struct ClientMobileApplicationMessageResponseFetchedProperties {
} ClientMobileApplicationMessageResponseFetchedProperties;








@interface ClientMobileApplicationMessageResponseID : NSManagedObjectID {}
@end

@interface _ClientMobileApplicationMessageResponse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ClientMobileApplicationMessageResponseID*)objectID;





@property (nonatomic, strong) NSString* clientMobileApplicationKey;



//- (BOOL)validateClientMobileApplicationKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* clientPlaceholder;



//- (BOOL)validateClientPlaceholder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* placeholder;



//- (BOOL)validatePlaceholder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;






@end

@interface _ClientMobileApplicationMessageResponse (CoreDataGeneratedAccessors)

@end

@interface _ClientMobileApplicationMessageResponse (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveClientMobileApplicationKey;
- (void)setPrimitiveClientMobileApplicationKey:(NSString*)value;




- (NSString*)primitiveClientPlaceholder;
- (void)setPrimitiveClientPlaceholder:(NSString*)value;




- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitivePlaceholder;
- (void)setPrimitivePlaceholder:(NSString*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




@end
