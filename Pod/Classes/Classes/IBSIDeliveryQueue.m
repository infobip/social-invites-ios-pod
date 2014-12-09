//
//  IBSIDeliveryQueue.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/29/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "IBSIDeliveryQueue.h"

@implementation IBSIDeliveryQueue

@synthesize queue;

#pragma mark - Singleton methods

+ (id)sharedInstance {
    static IBSIDeliveryQueue *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        queue = [[NSOperationQueue alloc] init];
        queue.name = @"DeliveryReport Queue";
    }
    return self;
}

@end
