//
//  IBSIPerson.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/8/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IBSIInvitationInfo.h"

@interface IBSIPerson : NSObject

@property(readonly) NSInteger personId;
@property(nonatomic, copy, readonly) NSString *name;       // alias for compositeName
@property(nonatomic, copy) NSString *firstName;            // kABPersonFirstNameProperty
@property(nonatomic, copy) NSString *lastName;             // kABPersonLastNameProperty
@property(nonatomic, copy) NSArray *phoneNumbers;
@property(nonatomic) NSArray *invitationInfos;

/**-----------------------------------------------------------------------------
 * @name Initialization
 * -----------------------------------------------------------------------------
 */

/**
 * Initialize new Person object
 *
 * @param person perosn ID form Addressbook
 * @author MMiroslav
 * @since v1.0
 */
- (IBSIPerson *)initWithPerson:(id)person;

/**-----------------------------------------------------------------------------
 * @name Invite
 * -----------------------------------------------------------------------------
 */

/**
 * Send Social Invite to all MSISDNs of person
 *
 * @param deliveryDelegate
 * @param messageId (optional) in nil is passed, default message will be sent
 * @author NKolarevic
 * @since v1.0
 */
- (void)sendInviteWithDeliveryDelegate:(id)deliveryDelegate messageId:(NSString *)messageId;

/**
 * Returns number of non invited MSISDN for person
 *
 * @see @IBSIInvitationInfo#-isInvited
 * @return number of prsons
 * @author MMiroslav
 * @since v1.0
 */
- (NSInteger)numberOfNonInvitedMsisdns;

/**-----------------------------------------------------------------------------
 * @name Social Invite Delivery management
 * -----------------------------------------------------------------------------
 */

/**
 * Person delivery status based on InvitaionInfo statuses
 *
 * @return IBSIDeliveryStatus person delivery status
 * @author MMiroslav
 * @since v1.0
 */
- (IBSIDeliveryStatus)deliveryStatus;

/**
 * Update delivery statuses for all MSISDNs
 *
 * @author MMiroslav
 * @since v1.0
 */
- (void)updateDeliveryStatus;

/**
 * Return all bulk IDs for person
 *
 * @return set of bulk IDs
 * @author MMiroslav
 * @since v1.0
 */
- (NSSet *)allBulkIds;

/**
 * Initiate delivery status request to server in separate thread.
 * If person is not in terminal state process will be repeted 10 times with pausa beetwin every two requests
 *
 * @see @IBSIPerson#-requestDeliveryStatusInSeparateThreadWithDelegate:atIndexPath:
 * @param id<IBSIDeliveryReportDelegate> delegate Anounceing when thread is finished or state changed
 * @author MMiroslav
 * @since v1.0
 */
- (void)requestDeliveryStatusInSeparateThreadWithDelegate:(id)delegate;

/**
 * Initiate delivery status request to server in separate thread.
 * If person is not in terminal state process will be repeted 10 times with pausa beetwin every two requests
 *
 * @param id<IBSIDeliveryReportDelegate> delegate Anounceing when thread is finished or state changed
 * @param NSIndexPath indexPath of person
 * @author MMiroslav
 * @since v1.0
 */
- (void)requestDeliveryStatusInSeparateThreadWithDelegate:(id)delegate atIndexPath:(NSIndexPath *)indexPath;


/**-----------------------------------------------------------------------------
 * @name Person invitation states
 * -----------------------------------------------------------------------------
 */

/**
 *  If all MSISDNs is in terminal state, than person is in terminal state
 * 
 * @see @IBSIInvitationInfo#-inTerminalState
 * @return (BOOL)
 * @author MMiroslav
 * @since v1.0
 */
- (BOOL)inTerminalState;

/**
 * If at list one MSISDN is in pending state, than person is in pennding state
 *
 * @see @IBSIInvitationInfo#-isPending
 * @return (BOOL)
 * @author MMiroslav
 * @since v1.0
 */
- (BOOL)isInPendingState;

/**
 * If at list one MSISDN is succesfully invited, than person is invited
 *
 * @see @IBSIInvitationInfo#-isPending
 * @return (BOOL)
 * @author MMiroslav
 * @since v1.0
 */
- (BOOL)isInvited;

/**-----------------------------------------------------------------------------
 * @name Person image
 * -----------------------------------------------------------------------------
 */

/**
 * If person has image in Address Book return YES
 *
 * @see @IBSIPerson#-thumbnail
 * @return (BOOL)
 * @author MMiroslav
 * @since v1.0
 */
- (BOOL)hasImage;

/**
 * Returnes persons image
 *
 * @see @IBSIPerson#-hasImage
 * @return (BOOL)
 * @author MMiroslav
 * @since v1.0
 */
- (UIImage *)thumbnail;

@end