//
//  IBSIInvitationInfo.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/8/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "IBSIInvitationInfo.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "IBSIUtils.h"
#import "IBSIInvite.h"
#import "IBSIPerson.h"
#import "IBSIAddressBook.h"

#import "NBPhoneNumberUtil.h"
#import "NBPhoneNumber.h"


@implementation IBSIInvitationInfo

@synthesize msisdn = _msisdn;
@synthesize personId = _personId;
@synthesize deliveryStatus = _deliveryStatus;
@synthesize bulkId = _bulkId;

#pragma mark - Inits
- (IBSIInvitationInfo *)initWithMsisdn:(NSString *)msisdn personId:(NSInteger)personId {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.msisdn = msisdn;
    self.personId = personId;
    self.deliveryStatus = IBSIDeliveryStatusNotSet;
    return self;
}

- (IBSIInvitationInfo *)initWithMsisdn:(NSString *)msisdn personId:(NSInteger)personId bulkId:(NSString *)bulkId deliveryStatus:(NSString *)status {
    self.msisdn = msisdn;
    self.personId = personId;
    self.bulkId = bulkId;
    self.deliveryStatus = [self statusToEnum:status];
    return self;
}

- (IBSIDeliveryStatus)deliveryStatus {
    if (!_deliveryStatus) {
        _deliveryStatus = IBSIDeliveryStatusNotSet;
    }
    return _deliveryStatus;
}

- (void)setDeliveryStatus:(IBSIDeliveryStatus)deliveryStatus {
    _deliveryStatus = deliveryStatus;
}

#pragma mark - Class utils
/**
 Convert string status to enum
 
 @author MMiroslav
 @param status (NSString)
 @return IBSIDeliveryStatus status
 */
- (int)statusToEnum:(NSString *)status {
    if ([@"DeliveredToTerminal" isEqual:status]) {
        return IBSIDeliveryStatusDeliveredToTerminal;
    } else if ([@"DeliveryUncertain" isEqual:status]) {
        return IBSIDeliveryStatusDeliveryUncertain;
    } else if ([@"DeliveryImpossible" isEqual:status]) {
        return IBSIDeliveryStatusDeliveryImpossible;
    } else if ([@"MessageWaiting" isEqual:status]) {
        return IBSIDeliveryStatusMessageWaiting;
    } else if ([@"DeleveredToNetwork" isEqual:status]) {
        return IBSIDeliveryStatusDeleveredToNetwork;
    } else if ([@"DeliveryUnknown" isEqual:status]) {
        return IBSIDeliveryStatusUnknown;
    } else if ([@"DeliveryUndefined" isEqual:status]) {
        return IBSIDeliveryStatusUndefined;
    } else if (status == nil) {
        return IBSIDeliveryStatusNotSet;
    } else {
        return IBSIDeliveryStatusUndefined;
    }
}

/**
 Returns formatted MSISDN
 
 @author MMiroslav
 @return (NSString) formatted MSISDN
 */
- (NSString *)formattedMsisdn {
    return [IBSIUtils formatMsisdn:self.msisdn];
}


# pragma mark - Invite

- (void)sendInviteWithDeliveryDelegate:(id)deliveryDelegate messageId:(NSString *)messageId {

    IBSIPerson *person = [[InfobipSocialInvite addressBook] personWithId:self.personId];
    NSMutableArray *recipients = [NSMutableArray new];
    // NSString *messageId = [InfobipSocialInvite defaultMessageId];

    // TODO refactor
    if (![InfobipSocialInvite socialInviteResending]) {
        if (self.deliveryStatus != IBSIDeliveryStatusUnknown) {
            if (self.bulkId == nil) {
                for (IBSIInvitationInfo *info in person.invitationInfos) {
                    if ([[self formattedMsisdn] isEqualToString:[info formattedMsisdn]] && info.bulkId != nil) {
                        self.bulkId = info.bulkId;
                    }
                }
                if (self.bulkId == nil) {
                    [recipients addObject:[self formattedMsisdn]];
                }
            }
        }
    } else {
        [recipients addObject:[self formattedMsisdn]];
    }
    // send invite to msisdn, by calling manager method sendSocialInviteToRecipients
    if (recipients.count != 0) {
        // TODO remove this! Only for Demo App purposes
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"invitesEnabled"] boolValue]) {

            if ([InfobipSocialInvite isLibraryInitialized]) {
                // add items to DB
                [IBSIInvite updateDatabaseWithInvitationInfo:self];
                self.deliveryStatus = IBSIDeliveryStatusUnknown;

                __block IBSIPerson *blockPerson = person;
                __block IBSIInvitationInfo *blockSelf = self;
                [InfobipSocialInvite sendSocialInviteToRecipients:recipients withMessageId:messageId clientData:nil
                                                     successBlock:^(SendSmsResponse *result) {
                                                         NSLog(@"bulkId: %@", result.bulkId);
                                                         NSLog(@"deliveryInfo: %@", result.deliveryInfoUrl);
                                                         for (IBSIInvitationInfo *info in blockPerson.invitationInfos) {
                                                             if ([[blockSelf formattedMsisdn] isEqualToString:[info formattedMsisdn]]) {
                                                                 info.bulkId = result.bulkId;
                                                                 if ([InfobipSocialInvite deliveryReportEnable]) {
                                                                     info.deliveryStatus = IBSIDeliveryStatusMessageWaiting;
                                                                 } else {
                                                                     info.deliveryStatus = IBSIDeliveryStatusDeliveredToTerminal;
                                                                 }
                                                             }
                                                         }
                                                     }
                                                     failureBlock:^(NSError *error) {
                                                         NSLog(@"Error: %@", [error description]);
                                                         for (IBSIInvitationInfo *info in blockPerson.invitationInfos) {
                                                             if ([[blockSelf formattedMsisdn] isEqualToString:[info formattedMsisdn]] && info.deliveryStatus == IBSIDeliveryStatusUnknown) {
                                                                 info.deliveryStatus = IBSIDeliveryStatusNotSet;
                                                             }
                                                         }
                                                     }];
                [self requestDeliveryStatusInSeparateThreadWithDelegate:deliveryDelegate];
            } else {
                NSLog(@"Library isn't initialized!");
            }
        }
    }
}


/**
 Return YES if msisdn is in terminal state
 
 @author MMiroslav
 @return (BOOL)
 */
- (BOOL)inTerminalState {
    if ((self.deliveryStatus == IBSIDeliveryStatusMessageWaiting) ||
            (self.deliveryStatus == IBSIDeliveryStatusUnknown)) {
        return NO;
    }
    return YES;
}

/**
 Return YES if invitation is successfully sent to msisdn
 
 @author MMiroslav
 @return (BOOL)
 */
- (BOOL)isInvited {
    if ((self.deliveryStatus == IBSIDeliveryStatusDeleveredToNetwork) ||
            (self.deliveryStatus == IBSIDeliveryStatusDeliveredToTerminal) ||
            (self.deliveryStatus == IBSIDeliveryStatusDeliveryUncertain)) {
        return YES;
    }
    return NO;
}

/**
 Return YES if invitation is waiting to be sent to msisdn
 
 @author MMiroslav
 @return (BOOL)
 */
- (BOOL)isPending {
    if ((self.deliveryStatus == IBSIDeliveryStatusMessageWaiting) ||
            (self.deliveryStatus == IBSIDeliveryStatusUnknown)) {
        return YES;
    }
    return NO;
}

/**
 Return YES if invitation is impossible to sent to msisdn
 
 @author MMiroslav
 @return (BOOL)
 */
- (BOOL)isInImpossibleState {
    if ((self.deliveryStatus == IBSIDeliveryStatusDeliveryImpossible) ||
            (self.deliveryStatus == IBSIDeliveryStatusUndefined)) {
        return YES;
    }
    return NO;
}

#pragma mark - Delivery

/**
 Update object with delivery status from Database
 
 @author MMiroslav
 */
- (void)updateDeliveryStatus {
    [self setDeliveryStatus:[self statusToEnum:[IBSIInvite deliveryStatusForMsisdn:[self formattedMsisdn]]]];
}

/**
 @see requestDeliveryStatusInSeparateThreadWithDelegate:atIndexPath:
 
 @param id<IBSIDeliveryReportDelegate> delegate Announcing when thread is finished or state changed
 @author MMiroslav
 */
- (void)requestDeliveryStatusInSeparateThreadWithDelegate:(id)delegate {
    [self requestDeliveryStatusInSeparateThreadWithDelegate:delegate atIndexPath:nil];
}

/**
 Request delivery status from server for person with this MSISDN
 
 @param id<IBSIDeliveryReportDelegate> delegate Announcing when thread is finished or state changed
 @param NSIndexPath indexPath of person
 @author MMiroslav
 */
- (void)requestDeliveryStatusInSeparateThreadWithDelegate:(id)delegate atIndexPath:(NSIndexPath *)indexPath {
    if (![self inTerminalState]) {
        [[[InfobipSocialInvite addressBook] personWithId:self.personId] requestDeliveryStatusInSeparateThreadWithDelegate:delegate];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"InvitationInfo:\n MSISDN: %@,\n personId: %ld,\n bulkId: %@,\n deliveryStatus: %ld\n", self.msisdn, (long) self.personId, self.bulkId, (long) self.deliveryStatus];
}

@end
