//
//  IBSIAddressBook.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/8/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSIPerson.h"

//authorization status enum.
typedef enum IBSIAuthorizationStatus {
    IBSIAuthorizationStatusNotDetermined = 0,
    IBSIAuthorizationStatusRestricted,
    IBSIAuthorizationStatusDenied,
    IBSIAuthorizationStatusAuthorized
} IBSIAuthorizationStatus;

@interface IBSIAddressBook : NSObject

@property(nonatomic, strong) NSArray *persons;
@property NSMutableArray *invitedPersons;
@property NSMutableArray *uninvitedPersons;

/**-----------------------------------------------------------------------------
 * @name People
 * -----------------------------------------------------------------------------
 */

/**
 * Number of people in address book.
 *
 * @author NKolarevic
 * @since v1.0
 */
- (long)numberOfPeople;
/**-----------------------------------------------------------------------------
 * @name People
 * -----------------------------------------------------------------------------
 */

/**
 * People ordered by first name with at least one phone number.
 *
 * @author NKolarevic
 * @since v1.0
 */
- (NSArray *)peopleOrderedByFirstName;
/**-----------------------------------------------------------------------------
 * @name People
 * -----------------------------------------------------------------------------
 */
/**
 * People ordered by last name with at least one phone number.
 *
 * @author NKolarevic
 * @since v1.0
 */

- (NSArray *)peopleOrderedByLastName;

/**-----------------------------------------------------------------------------
 * @name People
 * -----------------------------------------------------------------------------
 */

/**
 * Get person by person id.
 *
 * @param personId Unique identifier for person
 * @author NKolarevic
 * @since v1.0
 */
- (IBSIPerson *)personWithId:(NSInteger)personId;

/**-----------------------------------------------------------------------------
 * @name People
 * -----------------------------------------------------------------------------
 */

/**
 * Get person with msisdn.
 * If more then one person has the same msisdn it will be returned the first one.
 *
 * @param msisdn Phone number
 * @author NKolarevic
 * @since v1.0
 */
- (IBSIPerson *)personWithMsisdn:(NSString *)msisdn;

- (NSInteger)countPersonsWithId:(NSInteger)personId; //TESTING

+ (IBSIAuthorizationStatus)authorizationStatus;

- (void)requestAuthorizationWithCompletion:(void (^)(bool granted, NSError *error))completion;

- (NSMutableArray *)searchThroughPeople:(NSArray *)people withText:(NSString *)searchText;

- (void)requestDeliveryStatusAndUpdatePendingInvitationsWithDelegate:(id)delegate;

- (void)updateDatabaseDeleteItemsWithoutBulkId;

// TODO temp methods
- (BOOL)isInvitationSentToPersonId:(NSInteger)personId;

- (BOOL)isInvitationSentToMsisdn:(NSString *)msisdn;

#pragma mark -
- (id)getRHAddressBook;

@end
