//
//  IBSIAddressBook.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/8/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "IBSIAddressBook.h"
#import "IBSIInvite.h"
#import "IBSIInvitationInfo.h"
#import "AddressBook.h"
#import "IBSIDeliveryQueue.h"
#import "IBSIDeliveryReportOperation.h"
#include "IBSIUtils.h"


@interface IBSIAddressBook ()

@property(nonatomic, strong) RHAddressBook *rhAddressBook;
@end

@implementation IBSIAddressBook

@synthesize rhAddressBook = _rhAddressBook;
@synthesize persons = _persons;
@synthesize invitedPersons = _invitedPersons;
@synthesize uninvitedPersons = _uninvitedPersons;

#pragma mark - Inits

- (NSArray *)invitedPersons {
    [self populateInvitedAndUninvitedPersons];
    return _invitedPersons;
}

- (void)setInvitedPersons:(NSArray *)invitedPersons {
    _invitedPersons = [invitedPersons mutableCopy];
}

- (NSArray *)uninvitedPersons {
    [self populateInvitedAndUninvitedPersons];
    return _uninvitedPersons;
}

- (void)setUninvitedPersons:(NSArray *)uninvitedPersons {
    _uninvitedPersons = [uninvitedPersons mutableCopy];
}


- (NSArray *)persons {
    if (!_persons) {
        _persons = [self allPersons];
        [self updatePersons];
    }
    return _persons;
}

- (void)setPersons:(NSArray *)persons {
    _persons = persons;
}

- (RHAddressBook *)rhAddressBook {
    if (!_rhAddressBook) {
        _rhAddressBook = [[RHAddressBook alloc] init];
    }
    return _rhAddressBook;
}

- (void)setRhAddressBook:(RHAddressBook *)addressBook {
    _rhAddressBook = addressBook;
}

- (id)getRHAddressBook {
    return self.rhAddressBook;
}

#pragma mark - People

- (NSArray *)peopleWithPhoneNumber:(NSArray *)people {
    NSMutableArray *tmpPeople = [NSMutableArray new];
    IBSIPerson *person; // WARNING memory consumption
    for (int i = 0; i < [people count]; i++) {
        person = [people objectAtIndexedSubscript:i];
        if ([[person phoneNumbers] count] != 0) {
            [tmpPeople addObject:person];
        }
    }
    return [tmpPeople copy];
}

- (NSArray *)allPersons {
    NSMutableArray *tmpPersons = [[NSMutableArray alloc] init];
    for (RHPerson *person in self.rhAddressBook.people) {
        IBSIPerson *tmpPerson = [[IBSIPerson alloc] initWithPerson:person];
        [tmpPersons addObject:tmpPerson];
    }
    return [self peopleWithPhoneNumber:tmpPersons];
}

- (long)numberOfPeople {
    return [self.persons count];
}

- (NSArray *)peopleOrderedByFirstName {
    NSArray *tmpPeople = [[NSMutableArray alloc] init];
    tmpPeople = [self.rhAddressBook peopleOrderedByFirstName];
    NSMutableArray *tmpPersons = [[NSMutableArray alloc] init];
    for (RHPerson *person in tmpPeople) {
        IBSIPerson *tmpPerson = [[IBSIPerson alloc] initWithPerson:person];
        [tmpPersons addObject:tmpPerson];
    }
    self.persons = [self peopleWithPhoneNumber:tmpPersons];
    [self updatePersons];
    return self.persons;
}

- (NSArray *)peopleOrderedByLastName {
    NSArray *tmpPeople = [[NSMutableArray alloc] init];
    tmpPeople = [self.rhAddressBook peopleOrderedByLastName];
    NSMutableArray *tmpPersons = [[NSMutableArray alloc] init];
    for (RHPerson *person in tmpPeople) {
        IBSIPerson *tmpPerson = [[IBSIPerson alloc] initWithPerson:person];
        [tmpPersons addObject:tmpPerson];
    }
    self.persons = [self peopleWithPhoneNumber:tmpPersons];
    [self updatePersons];
    return self.persons;

}

- (IBSIPerson *)personWithId:(NSInteger)personId {
    for (IBSIPerson *object in self.persons) {
        if (object.personId == personId) {
            return object;
        }
    }
    return nil;
}

- (IBSIPerson *)personWithMsisdn:(NSString *)msisdn {
    for (IBSIPerson *person in self.persons) {
        for (IBSIInvitationInfo *info in person.phoneNumbers) {
                if ([[info formattedMsisdn] isEqualToString: [IBSIUtils formatMsisdn:msisdn]]) {
                return person;
            }
        }

    }
    return nil;
}


- (NSInteger)countPersonsWithId:(NSInteger)personId {
    NSInteger i = 0;
    for (IBSIPerson *object in self.persons) {
        if (object.personId == personId) {
            i++;
        }
    }
    return i;
}

#pragma mark - Invitations

/**
 If invitedPersons contains person with personId return YES
 @param personId
 @author MMiroslav
 @return (BOOL)
 */
- (BOOL)isInvitationSentToPersonId:(NSInteger)personId {
    for (IBSIPerson *tmpPerson in self.invitedPersons) {
        if (tmpPerson.personId == personId) {
            return YES;
        }
    }
    return NO;
}

/**
 Check is MSISDN in array of sent invitations
 
 @param msisdn
 @author MMiroslav
 @return (BOOL)
 */
- (BOOL)isInvitationSentToMsisdn:(NSString *)msisdn {
    for (IBSIInvitationInfo *invitationInfo in [IBSIInvite allInvites]) {
        if ([[IBSIUtils formatMsisdn:msisdn] isEqualToString:[invitationInfo formattedMsisdn]]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Authorization

+ (IBSIAuthorizationStatus)authorizationStatus {
    return (IBSIAuthorizationStatus) [RHAddressBook authorizationStatus];
}

- (void)requestAuthorizationWithCompletion:(void (^)(bool granted, NSError *error))completion {
    [self.rhAddressBook requestAuthorizationWithCompletion:completion];

}

#pragma mark - Search

- (NSMutableArray *)searchThroughPeople:(NSArray *)people withText:(NSString *)searchText {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[search] %@", searchText];
    return [[people filteredArrayUsingPredicate:resultPredicate] mutableCopy];
}

#pragma mark - Update Persons

- (void)updatePersons {
    NSArray *allInvites = [IBSIInvite allInvites];
    for (IBSIInvitationInfo *invitedInfo in allInvites) {
        IBSIPerson *person = [self personWithId:invitedInfo.personId];
        for (IBSIInvitationInfo *info in person.invitationInfos) {
            if ([info.formattedMsisdn isEqualToString:invitedInfo.formattedMsisdn]) {
                info.bulkId = invitedInfo.bulkId;
                info.deliveryStatus = invitedInfo.deliveryStatus;
            }
        }
    }
}

/**
 Request delivery status for all invitations in non Terminal state
 
 @author MMiroslav
 */
- (void)requestDeliveryStatusAndUpdatePendingInvitationsWithDelegate:(id)delegate {
    [self updateDatabaseDeleteItemsWithoutBulkId];
    for (IBSIPerson *person in [self invitedPersons]) {
        if (![person inTerminalState]) {
            IBSIDeliveryReportOperation *deliveryThread = [[IBSIDeliveryReportOperation alloc] initWithPerson:person delegate:delegate];
            deliveryThread.numberOfRepeatings = 2;
            deliveryThread.pauseInSeconds = 10;
            [[[IBSIDeliveryQueue sharedInstance] queue] addOperation:deliveryThread];
        }
    }
}

/**
 Remove all items form deliveryInfo entity without bulkId
 
 @author MMiroslav
 */
- (void)updateDatabaseDeleteItemsWithoutBulkId {
    [IBSIInvite updateDatabaseDeleteItemsWithoutBulkId];
}

#pragma mark - Private methods

- (void)populateInvitedAndUninvitedPersons {
    if (!_invitedPersons) {
        _invitedPersons = [NSMutableArray new];
    }
    if (!_uninvitedPersons) {
        _uninvitedPersons = [[self persons] mutableCopy];
    }
    NSArray *allInvites = [IBSIInvite allInvites];
    for (IBSIInvitationInfo *invitationInfo in allInvites) {
        IBSIPerson *tmpPerson = [self personWithId:invitationInfo.personId];
        if (![_invitedPersons containsObject:tmpPerson]) {
            [_invitedPersons addObject:tmpPerson];
            [_uninvitedPersons removeObject:tmpPerson];
        }
    }
}

@end
