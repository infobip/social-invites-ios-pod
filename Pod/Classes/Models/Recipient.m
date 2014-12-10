#import "Recipient.h"


@interface Recipient ()

// Private interface goes here.

@end


@implementation Recipient

+ (Recipient *)new:(RKObjectManager *)objectManager {
    Recipient *recipients = [[Recipient alloc] initWithEntity:[NSEntityDescription entityForName:NSStringFromClass([Recipient class]) inManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext] insertIntoManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext];
    return recipients;
}

@end
