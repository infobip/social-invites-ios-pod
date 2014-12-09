//
//  IBSIUtils.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/14/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBSIUtils : NSObject

+ (NSBundle *)libraryBundle;

+ (BOOL)checkIsInternetConnectionReachable;

+ (NSString *)formatMsisdn:(NSString *)msisdn;
@end
