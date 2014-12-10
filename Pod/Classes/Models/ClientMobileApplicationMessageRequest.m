#import "ClientMobileApplicationMessageRequest.h"


@interface ClientMobileApplicationMessageRequest ()

// Private interface goes here.

@end


@implementation ClientMobileApplicationMessageRequest


+ (ClientMobileApplicationMessageRequest *)new:(RKObjectManager *)objectManager {
    ClientMobileApplicationMessageRequest *requestObject = [[ClientMobileApplicationMessageRequest alloc] initWithEntity:[NSEntityDescription entityForName:NSStringFromClass([ClientMobileApplicationMessageRequest class]) inManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext] insertIntoManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext];
    return requestObject;
}

@end
