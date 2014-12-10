//
//  IBSIPerson.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/8/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//
#import "IBSIAddressBook.h"
#import "IBSIPerson.h"
#import "IBSIInvitationInfo.h"
#import "RHPerson.h"
#import "InfobipSocialInvite.h"
#import "IBSIInvite.h"
#import "IBSIDeliveryReportOperation.h"
#import "IBSIDeliveryQueue.h"
#import "Models/SmsMessageResponse.h"

@interface IBSIPerson ()

@property(nonatomic) RHPerson *person;

@end

@implementation IBSIPerson

@synthesize invitationInfos = _invitationInfos;
@synthesize personId = _personId;
@synthesize name = _name;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize phoneNumbers = _phoneNumbers;
@synthesize person = _person;

#pragma mark - Overriding

- (BOOL)isEqual:(id)object {
    IBSIPerson *other = (IBSIPerson *) object;
    if (other == self) {
        return YES;
    }
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    if ([self personId] == [other personId]) {
        return YES;
    }
    return NO;
}


#pragma mark - Initialization
- (RHPerson *)person {
    if (!_person) {
        _person = [[RHPerson alloc] init];
    }
    return _person;
}

- (void)setPerson:(RHPerson *)person {
    _person = person;
}

- (IBSIPerson *)initWithPerson:(id)person {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setPerson:(RHPerson *) person];
    self.invitationInfos = self.phoneNumbers;
    return self;
}


#pragma mark Person Properties
- (NSInteger)personId {
    return (NSInteger) self.person.recordID;
}

- (NSString *)name {
    return self.person.name;
}

- (NSString *)firstName {
    return self.person.firstName;
}

- (void)setFirstName:(NSString *)firstName {
    self.person.firstName = firstName;
}

- (NSString *)lastName {
    return self.person.lastName;
}

- (void)setLastName:(NSString *)lastName {
    self.person.lastName = lastName;
}


# pragma mark Phone Numbers
- (NSArray *)phoneNumbers {
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.person.phoneNumbers.count; i++) {
        [phones addObject:[[IBSIInvitationInfo alloc] initWithMsisdn:[self.person.phoneNumbers valueAtIndex:i] personId:self.person.recordID]];
    }
    return [phones copy];
}

- (void)setPhoneNumbers:(NSArray *)phoneNumbers {
    // do nothing
}

- (NSArray *)phoneNumbersWithoutDuplicate {
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    for (IBSIInvitationInfo *info in self.phoneNumbers) {
        if (![phones containsObject:[info formattedMsisdn]]) {
            [phones addObject:[info formattedMsisdn]];
        }
    }
    return phones;
}


# pragma mark - Invite
- (void)sendInviteWithDeliveryDelegate:(id)deliveryDelegate messageId:(NSString *)messageId {
    NSMutableArray *recipients = [NSMutableArray new];
    for (int i = 0; i < [self phoneNumbersWithoutDuplicate].count; i++) {
        [recipients addObject:[[self phoneNumbersWithoutDuplicate] objectAtIndex:i]];
    }

    if (![InfobipSocialInvite socialInviteResending]) {
        NSMutableArray *tmpRecipients = [[NSMutableArray alloc] initWithArray:recipients];
        for (IBSIInvitationInfo *info in self.invitationInfos) {
            if (info.deliveryStatus != IBSIDeliveryStatusUnknown) {
                if (info.bulkId != nil) {
                    for (NSString *msisdn in tmpRecipients) {
                        if ([msisdn isEqualToString:info.formattedMsisdn]) {
                            [recipients removeObject:msisdn];
                        }
                    }
                }
            } else {
                [recipients removeObject:info.msisdn];
            }
        }
    }

    if (recipients.count != 0) {

        // TODO remove this! Only for Demo App purposes
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"invitesEnabled"] boolValue]) {

            // send invite to all phones, by calling manager method sendSocialInviteToRecipients
            if ([InfobipSocialInvite isLibraryInitialized]) {
                for (IBSIInvitationInfo *info in self.invitationInfos) {
                    [IBSIInvite updateDatabaseWithInvitationInfo:info];
                    info.deliveryStatus = IBSIDeliveryStatusUnknown;
                }

                __block IBSIPerson *blockSelf = self;
                [InfobipSocialInvite sendSocialInviteToRecipients:recipients withMessageId:messageId clientData:nil
                                                     successBlock:^(SendSmsResponse *result) {
                                                         NSLog(@"bulkId: %@", result.bulkId);
                                                         NSLog(@"deliveryInfo: %@", result.deliveryInfoUrl);
                                                         for (IBSIInvitationInfo *info in blockSelf.invitationInfos) {
                                                             info.bulkId = result.bulkId;
                                                             if ([InfobipSocialInvite deliveryReportEnable]) {
                                                                 info.deliveryStatus = IBSIDeliveryStatusMessageWaiting;
                                                             } else {
                                                                 info.deliveryStatus = IBSIDeliveryStatusDeliveredToTerminal;
                                                             }
                                                         }

                                                         for (SmsMessageResponse *response in result.responses) {
                                                             NSLog(@"response.messageId: %@", response.messageId);
                                                             NSLog(@"response.status: %@", response.status);
                                                             NSLog(@"response.price: %@", response.price);
                                                         }
                                                     }
                                                     failureBlock:^(NSError *error) {
                                                         NSLog(@"Error: %@", [error localizedDescription]);
                                                         for (IBSIInvitationInfo *info in blockSelf.invitationInfos) {
                                                             if (info.deliveryStatus == IBSIDeliveryStatusUnknown) {
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

- (NSInteger)numberOfNonInvitedMsisdns {
    NSInteger count = 0;
    for (IBSIInvitationInfo *info in self.invitationInfos) {
        if (info.isInvited) {
            count++;
        }
    }
    return [self.invitationInfos count] - count;
}


#pragma mark - Delivery
// TODO change this to something more efficiently
- (IBSIDeliveryStatus)deliveryStatus {
    NSMutableSet *statuses = [NSMutableSet new];
    for (IBSIInvitationInfo *info in self.invitationInfos) {
        IBSIDeliveryStatus status = info.deliveryStatus;
        NSValue *statusValue = [NSValue value:&status withObjCType:@encode(enum IBSIDeliveryStatus)];
        [statuses addObject:statusValue];
    }


    // if at least one InvitationInfo is in Terminal state different than
    // IBSIDeliveryStatusDeliveryImpossible and IBSIDeliveryStatusNotSet,
    // than person is in IBSIDeliveryStatusDeliveredToTerminal state
    for (NSValue *value in statuses) {
        IBSIDeliveryStatus status;
        [value getValue:&status];
        if ((status == IBSIDeliveryStatusDeleveredToNetwork) ||
                (status == IBSIDeliveryStatusDeliveredToTerminal) ||
                (status == IBSIDeliveryStatusDeliveryUncertain)) {
            return IBSIDeliveryStatusDeliveredToTerminal;
        }
    }

    // if at least one InvitationInfo is in Pending state
    // than person is in IBSIDeliveryStatusMessageWaiting state
    for (NSValue *value in statuses) {
        IBSIDeliveryStatus status;
        [value getValue:&status];
        if ((status == IBSIDeliveryStatusMessageWaiting) ||
                (status == IBSIDeliveryStatusUnknown)) {
            return IBSIDeliveryStatusMessageWaiting;
        }
    }

    // IBSIDeliveryStatusDeliveryImpossible
    for (NSValue *value in statuses) {
        IBSIDeliveryStatus status;
        [value getValue:&status];
        if ((status == IBSIDeliveryStatusDeliveryImpossible) ||
                (status == IBSIDeliveryStatusUndefined)) {
            return IBSIDeliveryStatusDeliveryImpossible;
        }
    }

    // IBSIDeliveryStatusNotSet
    for (NSValue *value in statuses) {
        IBSIDeliveryStatus status;
        [value getValue:&status];
        if (status == IBSIDeliveryStatusNotSet) {
            return IBSIDeliveryStatusNotSet;
        }
    }

    // default return
    return IBSIDeliveryStatusNotSet;
}

- (void)updateDeliveryStatus {
    for (IBSIInvitationInfo *info in self.invitationInfos) {
        [info updateDeliveryStatus];
    }
}

- (NSSet *)allBulkIds {
    NSMutableSet *bulkIds = [NSMutableSet new];
    for (IBSIInvitationInfo *info in [self invitationInfos]) {
        if (info.bulkId != nil) {
            [bulkIds addObject:info.bulkId];
        }
    }
    return bulkIds;
}

- (void)requestDeliveryStatusInSeparateThreadWithDelegate:(id)delegate {
    [self requestDeliveryStatusInSeparateThreadWithDelegate:delegate atIndexPath:nil];
}

- (void)requestDeliveryStatusInSeparateThreadWithDelegate:(id)delegate atIndexPath:(NSIndexPath *)indexPath {
    if (![self inTerminalState]) {
        IBSIDeliveryReportOperation *deliveryOperation = [[IBSIDeliveryReportOperation alloc] initWithPerson:self delegate:delegate];
        [deliveryOperation setNumberOfRepeatings:10];
        [[[IBSIDeliveryQueue sharedInstance] queue] addOperation:deliveryOperation];
    }
}

#pragma mark - Person states

- (BOOL)inTerminalState {
    for (IBSIInvitationInfo *info in self.invitationInfos) {
        if (![info inTerminalState]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isInPendingState {
    if (self.deliveryStatus == IBSIDeliveryStatusMessageWaiting) {
        return YES;
    }
    return NO;
}

- (BOOL)isInvited {
    for (IBSIInvitationInfo *info in self.invitationInfos) {
        if ([info isInvited]) {
            return YES;
        }
    }
    return NO;
}


# pragma mark - Image
- (BOOL)hasImage {
    return [self.person hasImage];
}

- (UIImage *)thumbnail {
    return [self.person thumbnail];
}

#pragma mark - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"Person:\n name: %@\n personId: %ld\n, invitaionInfos: %@\n", self.name,
                                      (long) self.personId, self.invitationInfos];
}

@end
