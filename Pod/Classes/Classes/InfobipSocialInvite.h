//
//  InfobipSocialInvite.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 3/5/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IBSIInvite;
@class IBSIAddressBook;
@class SendSmsResponse;
@class SmsMessageResponse;
@class SocialInviteDelivery;
@class ClientMobileApplicationMessageResponse;

typedef void (^IBSIResponseSuccess)(SendSmsResponse *sendResponse);

typedef void (^IBSIDeliveryResponseSuccess)(SocialInviteDelivery *deliveryResponse);

typedef void (^IBSIMessageResponseSuccess)(ClientMobileApplicationMessageResponse *messageResponse);

typedef void (^IBSIResponseFailure)(NSError *error);

typedef enum IBSIMessagePlaceholders {
    SENDER_NAME = 0,
    RECEIVER_NAME,
    CUSTOM_TEXT,
    END_USER_MSISDN,
    END_USER_USERNAME
} IBSIMessagePlaceholders;


@protocol InfobipSocialInviteDelegate;

@interface InfobipSocialInvite : NSObject

/**-----------------------------------------------------------------------------
 * @name Address Book
 * -----------------------------------------------------------------------------
 */

+ (IBSIAddressBook *)addressBook;

+ (void)setAddressBook:(IBSIAddressBook *)addressBook;

/**-----------------------------------------------------------------------------
 * @name Initialization
 * -----------------------------------------------------------------------------
 */

/**
 * Library initialization with clientData for client placeholders.
 *
 * @param applicationKey Application key for your application from Infobip portal.
 * @param secretKey Secret key for your application.
 * @param defaultMessageId Default message id for your application.
 * @param clientData Array of strings which will be used to replace client placeholder in default message.
 * @author NKolarevic
 * @since v1.0
 */
+ (void)initWithApplicationKey:(NSString *)applicationKey secretKey:(NSString *)secretKey defaultMessageId:(NSString *)defaultMsgId clientListForPlaceholders:(NSArray *)clientListForPlaceholders;

/**
 * Library initialization without clientData.
 *
 * @param applicationKey Application key for your application from Infobip portal.
 * @param secretKey Secret key for your application.
 * @param defaultMessageId Default message id for your application.
 * @author NKolarevic
 * @since v1.0
 */
+ (void)initWithApplicationKey:(NSString *)applicationKey secretKey:(NSString *)secretKey defaultMessageId:(NSString *)defaultMsgId;

/**
 * This method returns YES if the library is initialized, otherwise it returns NO.
 *
 * @author NKolarevic
 * @since v1.0
 */
+ (BOOL)isLibraryInitialized;

/**-----------------------------------------------------------------------------
 * @name Properties
 * -----------------------------------------------------------------------------
 */

+ (NSString *)secretKey;

+ (void)setSecretKey:(NSString *)secretKey;

+ (NSString *)applicationKey;

+ (void)setApplicationKey:(NSString *)appKey;

+ (NSString *)defaultMessageId;

+ (void)setDefaultMessageId:(NSString *)defaultMessageId;

+ (NSString *)defaultMessageText;

+ (void)setDefaultMessageText:(NSString *)defaultMessageText;

+ (NSString *)defaultMessageWithCustomText;

+ (void)setDefaultMessageWithCustomText:(NSString *)defaultMessageWithCustomText;

+ (NSString *)endUserMsisdn;

+ (void)setEndUserMsisdn:(NSString *)msisdn;

+ (NSString *)endUserUsername;

+ (void)setEndUserUsername:(NSString *)username;

+ (NSString *)customMessageText;

+ (void)setCustomMessageText:(NSString *)customMessageText;

+ (NSString *)clientPlaceholder;

+ (void)setClientPlaceholder:(NSString *)clientPlaceholder;

+ (NSArray *)clientListForPlaceholders;

+ (void)setClientListForPlaceholders:(NSArray *)clientListForPlaceholders;

+ (NSString *)senderId;

+ (void)setSenderId:(NSString *)senderId;

+ (BOOL)socialInviteResending;

+ (void)setSocialInviteResending:(BOOL)resend;

+ (BOOL)messageEditing;

+ (void)setMessageEditing:(BOOL)edit;

+ (BOOL)deliveryReportEnable;

+ (void)setDeliveryReportEnable:(BOOL)enable;

/**-----------------------------------------------------------------------------
 * @name Social Invite View
 * -----------------------------------------------------------------------------
 */

/**
 * Runs new storyboard that contains TableView with user contacts.
 *
 * @param viewController Current view controller
 * @param block triggered after storyboard is run
 * @author MMiroslav
 * @since v1.0
 */
+ (void)startSocialInviteView:(UIViewController *)viewController block:(void (^)())block;

/**-----------------------------------------------------------------------------
 * @name Persons
 * -----------------------------------------------------------------------------
 */

/**
 * Returns list of invited persons.
 *
 * @return Array of persons
 * @author MMiroslav
 * @since v1.0
 */
+ (NSArray *)invitedPersons;

/**
 * Returns list of uninvited persons.
 *
 * @return Array of persons
 * @author MMiroslav
 * @since v1.0
 */
+ (NSArray *)uninvitedPersons;

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
+ (void)sendSocialInviteToRecipients:(NSArray *)recipients withMessageId:(NSString *)messageId clientData:(NSArray *)clientData successBlock:(IBSIResponseSuccess)success failureBlock:(IBSIResponseFailure)failure;

/**-----------------------------------------------------------------------------
 * @name  Message editing
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
+ (void)getMessageByMessageId:(NSString *)messageId withSuccessBlock:(IBSIMessageResponseSuccess)success failureBlock:(IBSIResponseFailure)failure;

/**-----------------------------------------------------------------------------
 * @name Delivery Report
 * -----------------------------------------------------------------------------
 */

/**
 * Try to fetch delivery status from web server. If Invitation delivery statuses
 * are disabled failureBlock will be trigered.
 *
 * @param bulkId Invitation Bulk ID.
 * @param successBlock Block that will be trigered if getting delivery status is successful.
 * @param failureBlock Block that will be trigered if error occurred.
 * @author MMiroslav
 * @since v1.0
 */
+ (void)getDeliveryInfoByBulkId:(NSString *)balkId withSuccessBlock:(IBSIDeliveryResponseSuccess)success failureBlock:(IBSIResponseFailure)failure;

/**
 * Get delivery status for particular MSISDN, from database, NOT web server,
 * so data could be outdated.
 * First use +getSocialInviteDeliveryInfoByBulkId:successBlock:failureBlock:
 * to get delivery reports from web server.
 *
 * @see @InfobipSocialInvite#+getSocialInviteDeliveryInfoByBulkId:successBlock:failureBlock:
 * @param msisdn Phone number.
 * @author MMiroslav
 * @since v1.0
 */
+ (NSString *)deliveryStatusForMsisdn:(NSString *)msisdn;

/**-----------------------------------------------------------------------------
 * @name Message Placeholders
 * -----------------------------------------------------------------------------
 */

/**
 * Convert enum IBSIMessagePlaceholders to string.
 *
 * @param messagePlaceholders
 * @author NKolarevic
 * @since v1.0
 */
+ (NSString *)convertIBSIMessagePlaceholdersToString:(IBSIMessagePlaceholders)messagePlaceholders;

/**-----------------------------------------------------------------------------
 * @name Infobip Social Invite Delegate
 * -----------------------------------------------------------------------------
 */

/**
 * Set new InfobipSocialInvite delegate.
 *
 * @param newDelegate
 * @author NKolarevic
 * @since v1.0
 */
+ (void)setDelegate:(id <InfobipSocialInviteDelegate>)newDelegate;

@end

/**-----------------------------------------------------------------------------
 * @name Infobip Social Invite Delegate protocol
 * -----------------------------------------------------------------------------
 */

@protocol InfobipSocialInviteDelegate <NSObject>
@optional
/**
 * Receive error from send invite method.
 *
 * @param error Send invite error
 * @see InfobipSocialInvite#+sendSocialInviteToRecipients:withMessageId:successBlock:failureBlock:
 * @author NKolarevic
 * @since v1.0
 */
- (void)sendInviteDidReceiveResponseWithError:(NSError *)error;

/**
 * Receive error from get message method.
 *
 * @param error Get message error.
 * @see InfobipSocialInvite#+getMessageByMessageId:withSuccessBlock:failureBlock:
 * @author NKolarevic
 * @since v1.0
 */
- (void)getMessageDidReceiveResponseWithError:(NSError *)error;

/**
 * Receive error from get delivery info.
 *
 * @param error Get delivery info error.
 * @see InfobipSocialInvite#+getDeliveryInfoByBulkId:withSuccessBlock:failureBlock:
 * @author NKolarevic
 * @since v1.0
 */
- (void)getDeliveryInfoDidReceiveResponseWithError:(NSError *)error;

/**
 * Receive successful response from send invite method.
 *
 * @param response Successful response.
 * @see InfobipSocialInvite#+sendSocialInviteToRecipients:withMessageId:successBlock:failureBlock:
 * @author NKolarevic
 * @since v1.0
 */
- (void)sendInviteDidReceiveSuccessfulResponse:(SendSmsResponse *)response;

/**
 * Receive successful response from get message method.
 *
 * @param response Successful response.
 * @see InfobipSocialInvite#+getMessageByMessageId:withSuccessBlock:failureBlock:
 * @author NKolarevic
 * @since v1.0
 */
- (void)getMessageDidReceiveSuccessfulResponse:(ClientMobileApplicationMessageResponse *)response;

/**
 * Receive successful response from get delivery info.
 *
 * @param response Successful response.
 * @see InfobipSocialInvite#+getDeliveryInfoByBulkId:withSuccessBlock:failureBlock:
 * @author NKolarevic
 * @since v1.0
 */
- (void)getDeliveryInfoDidReceiveSuccessfulResponse:(SocialInviteDelivery *)response;

@end
