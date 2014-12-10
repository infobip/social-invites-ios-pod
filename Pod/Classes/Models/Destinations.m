#import "Destinations.h"


@interface Destinations ()

// Private interface goes here.

@end


@implementation Destinations

+ (Destinations *)newWithAddress:(NSString *)address messageId:(NSString *)messageId clientData:(NSArray *)clientData objectManager:(RKObjectManager *)objectManager {
    Destinations *destinations = [[Destinations alloc] initWithEntity:[NSEntityDescription entityForName:NSStringFromClass([Destinations class]) inManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext] insertIntoManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext];
    destinations.address = address;
    destinations.messageId = messageId;
    destinations.clientData = clientData;
    return destinations;
}
@end
