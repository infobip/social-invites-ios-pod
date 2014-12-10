//
//  IBSIUtils.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/14/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "IBSIUtils.h"
#import "Reachability.h"
#import "NBPhoneNumberUtil.h"
#import "NBPhoneNumber.h"

#ifdef IBCORE
    #define IBSI_BUNDLE_NAME @"ResourcesCore"
#else
#define IBSI_BUNDLE_NAME @"Resources"
#endif

#define IBSI_BUNDLE_TYPE @"bundle"

@implementation IBSIUtils

+(NSBundle *)libraryBundle {
    NSString * bundlePath = [[NSBundle bundleForClass:[IBSIUtils class]] pathForResource:IBSI_BUNDLE_NAME ofType:IBSI_BUNDLE_TYPE];
    return [NSBundle bundleWithPath:bundlePath];
}

+ (BOOL)checkIsInternetConnectionReachable {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];

    return networkStatus == NotReachable ? NO : YES;
}

+ (NSString *)formatMsisdn:(NSString *)msisdn {
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstanceWithBundle:[IBSIUtils libraryBundle]];
    NSError *aError = nil;

    NSString *regionCode = [phoneUtil countryCodeByCarrier];
    if ([regionCode isEqual:@"cs"]) {
        regionCode = @"rs";
    }

    NBPhoneNumber *number = [phoneUtil parse:msisdn defaultRegion:regionCode error:&aError];
    return [phoneUtil normalizeDigitsOnly:[phoneUtil format:number numberFormat:NBEPhoneNumberFormatE164 error:&aError]];
}

@end
