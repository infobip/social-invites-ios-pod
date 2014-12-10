//
//  IBSIInvite.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 3/13/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models/SendSmsResponse.h"
#import "InfobipSocialInvite.h"
#import "Models/SocialInviteDelivery.h"
#import "Models/ClientMobileApplicationMessageResponse.h"
#import "Models/DeliveryInfo.h"
#import "IBSIInvitationInfo.h"


@interface IBSIInvite : NSObject


typedef void (^IBSIResponseSuccess)(SendSmsResponse *sendResponse);

typedef void (^IBSIDeliveryResponseSuccess)(SocialInviteDelivery *deliveryResponse);

typedef void (^IBSIMessageResponseSuccess)(ClientMobileApplicationMessageResponse *messageResponse);

typedef void (^IBSIResponseFailure)(NSError *error);

+ (void)setupRestKit;

/**-----------------------------------------------------------------------------
 * @name Social invite
 * -----------------------------------------------------------------------------
 */

/**
 * Send Social Invite to array of recipients.
 *
 * @param recipients Array of recipients.
 * @param messageId (optional) Mesage id for message witch will be sent to recepients. If nil is passed, default message will be sent.
 * @param clientData (optional) Client data for client placeholders. If it is nil clientListForPlaceholder will be used.
 * @param successBlock Block that will be trigered if invitation sending is successful.
 * @param failureBlock Block that will be trigered if error occurred.
 * @author MMiroslav
 * @since v1.0
 */
+ (void)sendInviteToRecipients:(NSArray *)recipients withMessageId:(NSString *)messageId clientData:(NSArray *)clientData successBlock:(IBSIResponseSuccess)successBlock failureBlock:(IBSIResponseFailure)failureBlock;

/**-----------------------------------------------------------------------------
 * @name Delivery status
 * -----------------------------------------------------------------------------
 */

/**
 * Try to fetch delivery status from web server. If Invitation delivery statuses
 * are disabled failureBlock will be trigered.
 *
 * @param bulkId Invitation Bulk ID
 * @param successBlock Block that will be trigered if getting delivery status is successful
 * @param failureBlock Block that will be trigered if error occurred
 * @author MMiroslav
 * @since v1.0
 */
+ (void)getSocialInviteDeliveryInfoByBulkId:(NSString *)bulkId withSuccessBlock:(IBSIDeliveryResponseSuccess)successBlock failureBlock:(IBSIResponseFailure)failureBlock;

/**
 * Get delivery status for particular MSISDN, from database, NOT web server,
 * so data could be outdated.
 * First use +getSocialInviteDeliveryInfoByBulkId:successBlock:failureBlock:
 * to get delivery reports from web server.
 *
 * @see @InfobipSocialInvite#+getSocialInviteDeliveryInfoByBulkId:successBlock:failureBlock:
 * @param msisdn Phone number
 * @author MMiroslav
 * @since v1.0
 */
+ (NSString *)deliveryStatusForMsisdn:(NSString *)msisdn;

/**-----------------------------------------------------------------------------
 * @name Invitation management
 * -----------------------------------------------------------------------------
 */

/**
 * This method return array of invitationInfo from database.
 *
 * @author MMiroslav
 * @since v1.0
 */
+ (NSArray *)allInvites;

/**-----------------------------------------------------------------------------
 * @name Message editing
 * -----------------------------------------------------------------------------
 */

/**
 * Get message text from web server by message id.
 *
 * @param messageId
 * @param successBlock Block that will be trigered if getting message is successful.
 * @param failureBlock Block that will be trigered if error occurred.
 * @author NKolarevic
 * @since v1.0
 */
+ (void)getMessageByMessageId:(NSString *)messageId withSuccessBlock:(IBSIMessageResponseSuccess)successBlock failureBlock:(IBSIResponseFailure)failureBlock;


/**-----------------------------------------------------------------------------
 * @name Updating Database
 * -----------------------------------------------------------------------------
 */

/**
 * Insert personId and phone number into database.
 * Message this immediatly after sending invite to MSISDN.
 *
 * @param invitationInfo
 * @author MMiroslav
 * @since v1.0
 */
+ (void)updateDatabaseWithInvitationInfo:(IBSIInvitationInfo *)invitationInfo;

/**
 * Set bulk ID to recipients records in database.
 *
 * @param bulkId Invitation Bulk ID.
 * @param recipients Array (NSString *) of recipients.
 * @author MMiroslav
 * @since v1.0
 */
+ (void)updateDatabaseWithBulkId:(NSString *)bulkId recipients:(NSArray *)recipients;

/**
 * Remove all items form deliveryInfo entity without bulkId.
 * Used at initialization to remove records created, in previews library activities, but never closed.
 *
 * @author MMiroslav
 * @since v1.0
 */
+ (void)updateDatabaseDeleteItemsWithoutBulkId;

/**
 * Set delivery status to Undefined for all recipients with MessageWaiting delivery status.
 *
 * @param bulkId Invitation Bulk ID
 * @author NKolarevic
 * @since v1.0
 */
+ (void)updateDatabaseWithUndefinedDeliveryStatusForBulkId:(NSString *)bulkId;


/**-----------------------------------------------------------------------------
 * @name Starting Social Invite storyboard
 * -----------------------------------------------------------------------------
 */

/**
 * Starts new storyboard with contacts list.
 *
 * @author MMiroslav
 * @since v1.0
 */
+ (void)startSocialInviteView:(UIViewController *)viewController block:(void (^)())block;
@end
