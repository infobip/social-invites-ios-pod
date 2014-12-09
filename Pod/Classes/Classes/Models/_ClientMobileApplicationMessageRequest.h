// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ClientMobileApplicationMessageRequest.h instead.

#import <CoreData/CoreData.h>


extern const struct ClientMobileApplicationMessageRequestAttributes {
	__unsafe_unretained NSString *clientPlaceholder;
	__unsafe_unretained NSString *placeholder;
	__unsafe_unretained NSString *text;
} ClientMobileApplicationMessageRequestAttributes;

extern const struct ClientMobileApplicationMessageRequestRelationships {
} ClientMobileApplicationMessageRequestRelationships;

extern const struct ClientMobileApplicationMessageRequestFetchedProperties {
} ClientMobileApplicationMessageRequestFetchedProperties;






@interface ClientMobileApplicationMessageRequestID : NSManagedObjectID {}
@end

@interface _ClientMobileApplicationMessageRequest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ClientMobileApplicationMessageRequestID*)objectID;





@property (nonatomic, strong) NSString* clientPlaceholder;



//- (BOOL)validateClientPlaceholder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* placeholder;



//- (BOOL)validatePlaceholder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;






@end

@interface _ClientMobileApplicationMessageRequest (CoreDataGeneratedAccessors)

@end

@interface _ClientMobileApplicationMessageRequest (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveClientPlaceholder;
- (void)setPrimitiveClientPlaceholder:(NSString*)value;




- (NSString*)primitivePlaceholder;
- (void)setPrimitivePlaceholder:(NSString*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




@end
