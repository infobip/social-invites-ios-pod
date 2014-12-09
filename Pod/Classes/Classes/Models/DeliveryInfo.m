#import "DeliveryInfo.h"
#import "RestKit.h"

@interface DeliveryInfo ()

// Private interface goes here.

@end


@implementation DeliveryInfo


+ (DeliveryInfo *)new {
    RKObjectManager *om = [RKObjectManager sharedManager];
    DeliveryInfo *requestObject = [[DeliveryInfo alloc] initWithEntity:[NSEntityDescription entityForName:NSStringFromClass([DeliveryInfo class]) inManagedObjectContext:om.managedObjectStore.persistentStoreManagedObjectContext] insertIntoManagedObjectContext:om.managedObjectStore.persistentStoreManagedObjectContext];
    return requestObject;
}

@end
