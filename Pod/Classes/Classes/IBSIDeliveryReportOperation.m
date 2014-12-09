//
//  IBSIDeliveryReportOperation.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/29/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "IBSIDeliveryReportOperation.h"
#import "InfobipSocialInvite.h"
#import "IBSIInvitationInfo.h"
#import "IBSIAddressBook.h"
#import "IBSIInvite.h"

#define IBSI_EXPIRED_DELIVERY_MESSAGE_ERROR @"Message not found for specified request ID"

@interface IBSIDeliveryReportOperation ()

@property(nonatomic, readwrite, strong) IBSIPerson *person;
@property(nonatomic, readwrite, strong) NSIndexPath *indexPath;

@end

@implementation IBSIDeliveryReportOperation

@synthesize delegate = _delegate;
@synthesize numberOfRepeatings = _numberOfRepeatings;
@synthesize pauseInSeconds = _pauseInSeconds;
@synthesize person = _person;
@synthesize indexPath = _indexPath;

#pragma mark - Initialization
- (NSInteger)numberOfRepeatings {
    if (!_numberOfRepeatings) {
        _numberOfRepeatings = 1;
    }
    return _numberOfRepeatings;
}

- (void)setNumberOfRepeatings:(NSInteger)numberOfRepeatings {
    _numberOfRepeatings = numberOfRepeatings;
}

- (NSInteger)pauseInSeconds {
    if (!_pauseInSeconds) {
        _pauseInSeconds = 8;
    }
    return _pauseInSeconds;
}

- (void)setPauseInSeconds:(NSInteger)pauseInSeconds {
    _pauseInSeconds = pauseInSeconds;
}


- (id)initWithPerson:(IBSIPerson *)person atIndexPath:(NSIndexPath *)indexPath delegate:(id <IBSIDeliveryReportDelegate>)theDelegate {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setPerson:person];
    [self setIndexPath:indexPath];
    [self setDelegate:theDelegate];
    return self;
}

- (id)initWithPerson:(IBSIPerson *)person delegate:(id <IBSIDeliveryReportDelegate>)theDelegate {
    return [self initWithPerson:person atIndexPath:nil delegate:theDelegate];
}

#pragma mark - Operations

- (void)main {
    @autoreleasepool {
        NSLog(@"Start processing delivery thread");
        if (self.isCancelled) {
            return;
        }
        int i = 0;
        while ((i < self.numberOfRepeatings) && (![self.person inTerminalState])) {
            if (self.isCancelled) {
                return;
            }

            //request delivery reports for person
            __block NSInteger personId = self.person.personId;
            __block IBSIDeliveryReportOperation *selfBlock = self;
            for (NSString *bulkId in [self.person allBulkIds]) {
                if (self.isCancelled) {
                    return;
                }
                __block IBSIDeliveryStatus personDeliveryStatus = [self.person deliveryStatus];

                [InfobipSocialInvite getDeliveryInfoByBulkId:bulkId withSuccessBlock:^(SocialInviteDelivery *deliveryResponse) {
                    [[[InfobipSocialInvite addressBook] personWithId:personId] updateDeliveryStatus];
                    // anaunce main therad that status is changed
                    if ([(NSObject *) self.delegate respondsToSelector:@selector(deliveryStatusDidChanged:)]) {
                        if ([[[InfobipSocialInvite addressBook] personWithId:personId] deliveryStatus] != personDeliveryStatus) {
                            [(NSObject *) selfBlock.delegate performSelectorOnMainThread:@selector(deliveryStatusDidChanged:) withObject:selfBlock waitUntilDone:NO];
                        }
                    }
                }                               failureBlock:^(NSError *error) {
                    [IBSIInvite updateDatabaseDeleteItemsWithoutBulkId];
                    NSLog(@"ERROR: %@", [error localizedDescription]);
                    if ([[error localizedDescription] isEqualToString:IBSI_EXPIRED_DELIVERY_MESSAGE_ERROR]) {
                        [IBSIInvite updateDatabaseWithUndefinedDeliveryStatusForBulkId:bulkId];
                        [[[InfobipSocialInvite addressBook] personWithId:personId] updateDeliveryStatus];

                        // Announce to main thread that status is changed
                        if ([(NSObject *) self.delegate respondsToSelector:@selector(deliveryStatusDidChanged:)]) {
                            if ([[[InfobipSocialInvite addressBook] personWithId:personId] deliveryStatus] != personDeliveryStatus) {
                                [(NSObject *) selfBlock.delegate performSelectorOnMainThread:@selector(deliveryStatusDidChanged:) withObject:selfBlock waitUntilDone:NO];
                            }
                        }


                    }
                    //TODO error handling
                }];
            }

            i++;

            // Wait until next try
            sleep([[NSNumber numberWithInteger:self.pauseInSeconds] intValue]);
            if (self.isCancelled) {
                return;
            }
        }

        if (self.isCancelled) {
            return;
        }
        if ([(NSObject *) self.delegate respondsToSelector:@selector(deliveryFetchDidFinish:)]) {
            [(NSObject *) self.delegate performSelectorOnMainThread:@selector(deliveryFetchDidFinish:) withObject:self waitUntilDone:NO];
        }
        NSLog(@"End procesing delivery thread");
    }
}
@end
