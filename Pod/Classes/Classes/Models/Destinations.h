#import "_Destinations.h"
#import "RestKit.h"

@interface Destinations : _Destinations {
}

+ (Destinations *)newWithAddress:(NSString *)address messageId:(NSString *)messageId clientData:(NSArray *)clientData objectManager:(RKObjectManager *)objectManager;

@end
