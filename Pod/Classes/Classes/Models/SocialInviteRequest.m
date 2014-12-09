#import "SocialInviteRequest.h"

@interface SocialInviteRequest ()

// Private interface goes here.

@end


@implementation SocialInviteRequest

+ (SocialInviteRequest *)new:(RKObjectManager *)objectManager {
    SocialInviteRequest *requestObject = [[SocialInviteRequest alloc] initWithEntity:[NSEntityDescription entityForName:NSStringFromClass([SocialInviteRequest class]) inManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext] insertIntoManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext];
    return requestObject;
}

@end
