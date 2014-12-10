#import "_Recipient.h"
#import "RestKit.h"

@interface Recipient : _Recipient {
}

+ (Recipient *)new:(RKObjectManager *)objectManager;

@end
