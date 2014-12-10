#import "_SocialInviteRequest.h"
#import "RestKit.h"


@interface SocialInviteRequest : _SocialInviteRequest {
}

+ (SocialInviteRequest *)new:(RKObjectManager *)objectManager;

@end
