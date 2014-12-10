//
//  InfobipSocialInvite.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 3/5/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "InfobipSocialInvite.h"
#import "IBSIAddressBook.h"
#import "IBSIInvite.h"

#define IBSI_PATH_SEND_INVITE @"1/social-invite/invitation"
#define IBSI_EXPIRED_DELIVERY_MESSAGE_ERROR @"Message not found for specified request ID"

@implementation InfobipSocialInvite

#pragma mark - Address Book

IBSIAddressBook *addressBook = nil;

+ (IBSIAddressBook *)addressBook {
    if (!addressBook) {
        addressBook = [[IBSIAddressBook alloc] init];
    }
    return addressBook;
}

+ (void)setAddressBook:(IBSIAddressBook *)aBook {
    addressBook = aBook;
}

#pragma mark - Properties

static id <InfobipSocialInviteDelegate> delegate;

static NSUserDefaults *userDefaults;

+ (void)initialize {
    NSLog(@"Initialize");
    userDefaults = [NSUserDefaults standardUserDefaults];
    // Default value for delivery report
    [InfobipSocialInvite setDeliveryReportEnable:YES];
}

+ (NSString *)applicationKey {
    return [userDefaults stringForKey:@"applicationKey"];
}

+ (void)setApplicationKey:(NSString *)appKey {
    [userDefaults setObject:appKey forKey:@"applicationKey"];
}

+ (NSString *)secretKey {
    return [userDefaults stringForKey:@"secretKey"];
}

+ (void)setSecretKey:(NSString *)secretKey {
    [userDefaults setObject:secretKey forKey:@"secretKey"];
}

+ (NSString *)defaultMessageId {
    return [userDefaults stringForKey:@"defaultMessageId"];
}

+ (void)setDefaultMessageId:(NSString *)defaultMessageId {
    [userDefaults setObject:defaultMessageId forKey:@"defaultMessageId"];
}

+ (NSString *)defaultMessageText {
    return [userDefaults stringForKey:@"defaultMessageText"];
}

+ (void)setDefaultMessageText:(NSString *)defaultMessageText {
    [userDefaults setObject:defaultMessageText forKey:@"defaultMessageText"];
}

+ (NSString *)defaultMessageWithCustomText {
    return [userDefaults stringForKey:@"defaultMessageWithCustomText"];
}

+ (void)setDefaultMessageWithCustomText:(NSString *)defaultMessageWithCustomText {
    [userDefaults setObject:defaultMessageWithCustomText forKey:@"defaultMessageWithCustomText"];
}

+ (NSString *)endUserMsisdn {
    return [userDefaults stringForKey:@"endUserMsisdn"];
}

+ (void)setEndUserMsisdn:(NSString *)msisdn {
    [userDefaults setObject:msisdn forKey:@"endUserMsisdn"];
}

+ (NSString *)endUserUsername {
    return [userDefaults stringForKey:@"endUserUsername"];
}

+ (void)setEndUserUsername:(NSString *)username {
    [userDefaults setObject:username forKey:@"endUserUsername"];
}

+ (NSString *)customMessageText {
    return [userDefaults stringForKey:@"customMessageText"];
}

+ (void)setCustomMessageText:(NSString *)customMessageText {
    [userDefaults setObject:customMessageText forKey:@"customMessageText"];
}

+ (NSString *)clientPlaceholder {
    return [userDefaults stringForKey:@"clientPlaceholder"];
}

+ (void)setClientPlaceholder:(NSString *)clientPlaceholder {
    [userDefaults setObject:clientPlaceholder forKey:@"clientPlaceholder"];
}

+ (NSArray *)clientListForPlaceholders {
    return [userDefaults arrayForKey:@"clientListForPlaceholders"];
}

+ (void)setClientListForPlaceholders:(NSArray *)clientListForPlaceholders {
    [userDefaults setObject:clientListForPlaceholders forKey:@"clientListForPlaceholders"];
}

+ (NSString *)senderId {
    return [userDefaults stringForKey:@"senderId"];
}

+ (void)setSenderId:(NSString *)senderId {
    [userDefaults setObject:senderId forKey:@"senderId"];
}

+ (BOOL)socialInviteResending {
    return [userDefaults boolForKey:@"resend"];
}

+ (void)setSocialInviteResending:(BOOL)resend {
    [userDefaults setBool:resend forKey:@"resend"];
}

+ (BOOL)messageEditing {
    return [userDefaults boolForKey:@"messageEdit"];
}

+ (void)setMessageEditing:(BOOL)edit {
    [userDefaults setBool:edit forKey:@"messageEdit"];
}

+ (BOOL)deliveryReportEnable {
    return [userDefaults boolForKey:@"deliveryReportEnable"];
}

+ (void)setDeliveryReportEnable:(BOOL)enable {
    [userDefaults setBool:enable forKey:@"deliveryReportEnable"];
}

#pragma mark - Initialization

bool isLibraryInit = NO;

+ (void)initWithApplicationKey:(NSString *)applicationKey secretKey:(NSString *)secretKey defaultMessageId:(NSString *)defaultMsgId clientListForPlaceholders:(NSArray *)clientListForPlaceholders {
    [self setApplicationKey:applicationKey];
    [self setSecretKey:secretKey];
    [self setDefaultMessageId:defaultMsgId];
    [self setClientListForPlaceholders:clientListForPlaceholders];
    [IBSIInvite setupRestKit];
    [self setSocialInviteResending:NO];
    [self setMessageEditing:NO];
    isLibraryInit = YES;
    //TODO: This is for demo app only, remove it
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"invitesEnabled"];
}

+ (void)initWithApplicationKey:(NSString *)applicationKey secretKey:(NSString *)secretKey defaultMessageId:(NSString *)defaultMsgId {
    [self initWithApplicationKey:applicationKey secretKey:secretKey defaultMessageId:defaultMsgId clientListForPlaceholders:nil];
}

+ (BOOL)isLibraryInitialized {
    return isLibraryInit;
}

#pragma mark - Social invite

+ (void)sendSocialInviteToRecipients:(NSArray *)recipients withMessageId:(NSString *)messageId clientData:(NSArray *)clientData successBlock:(IBSIResponseSuccess)success failureBlock:(IBSIResponseFailure)failure {
    [IBSIInvite sendInviteToRecipients:recipients withMessageId:messageId clientData:clientData successBlock:^(SendSmsResponse *sendResponse) {
        success(sendResponse);
        if ([(NSObject *) delegate respondsToSelector:@selector(sendInviteDidReceiveSuccessfulResponse:)]) {
            [(NSObject *) delegate performSelectorOnMainThread:@selector(sendInviteDidReceiveSuccessfulResponse:) withObject:sendResponse waitUntilDone:NO];
        }
    } failureBlock:^(NSError *error) {
        failure(error);
        if ([(NSObject *) delegate respondsToSelector:@selector(sendInviteDidReceiveResponseWithError:)]) {
            [(NSObject *) delegate performSelectorOnMainThread:@selector(sendInviteDidReceiveResponseWithError:) withObject:error waitUntilDone:NO];
        }
    }];
}

+ (void)startSocialInviteView:(UIViewController *)viewController block:(void (^)())block {
    [IBSIInvite startSocialInviteView:viewController block:^{
        block();
    }];
}

+ (NSArray *)invitedPersons {
    return [self.addressBook invitedPersons];
}

+ (NSArray *)uninvitedPersons {
    return [self.addressBook uninvitedPersons];
}

#pragma mark - Message editing

+ (void)getMessageByMessageId:(NSString *)messageId withSuccessBlock:(IBSIMessageResponseSuccess)success failureBlock:(IBSIResponseFailure)failure {
    [IBSIInvite getMessageByMessageId:messageId withSuccessBlock:^(ClientMobileApplicationMessageResponse *messageResponse) {
        success(messageResponse);
        if ([(NSObject *) delegate respondsToSelector:@selector(getMessageDidReceiveSuccessfulResponse:)]) {
            [(NSObject *) delegate performSelectorOnMainThread:@selector(getMessageDidReceiveSuccessfulResponse:) withObject:messageResponse waitUntilDone:NO];
        }
    }                    failureBlock:^(NSError *error) {
        failure(error);
        if ([(NSObject *) delegate respondsToSelector:@selector(getMessageDidReceiveResponseWithError:)]) {
            [(NSObject *) delegate performSelectorOnMainThread:@selector(getMessageDidReceiveResponseWithError:) withObject:error waitUntilDone:NO];
        }
    }];
}

#pragma mark - Delivery Report

+ (void)getDeliveryInfoByBulkId:(NSString *)bulkId withSuccessBlock:(IBSIDeliveryResponseSuccess)success failureBlock:(IBSIResponseFailure)failure {
    [IBSIInvite getSocialInviteDeliveryInfoByBulkId:bulkId withSuccessBlock:^(SocialInviteDelivery *deliveryResponse) {
        success(deliveryResponse);
        if ([(NSObject *) delegate respondsToSelector:@selector(getDeliveryInfoDidReceiveSuccessfulResponse:)]) {
            [(NSObject *) delegate performSelectorOnMainThread:@selector(getDeliveryInfoDidReceiveSuccessfulResponse:) withObject:deliveryResponse waitUntilDone:NO];
        }
    }                                  failureBlock:^(NSError *error) {
        failure(error);
        if ((![[error localizedDescription] isEqualToString:IBSI_EXPIRED_DELIVERY_MESSAGE_ERROR]) && [(NSObject *) delegate respondsToSelector:@selector(getDeliveryInfoDidReceiveResponseWithError:)]) {
            [(NSObject *) delegate performSelectorOnMainThread:@selector(getDeliveryInfoDidReceiveResponseWithError:) withObject:error waitUntilDone:NO];
        }
    }];
}

+ (NSString *)deliveryStatusForMsisdn:(NSString *)msisdn {
    return [IBSIInvite deliveryStatusForMsisdn:msisdn];
}

#pragma mark - InfobipSocialInviteDelegate

+ (id <InfobipSocialInviteDelegate>)delegate {
    return delegate;
}

+ (void)setDelegate:(id <InfobipSocialInviteDelegate>)newDelegate {
    delegate = newDelegate;
}

#pragma mark - Message placeholders

+ (NSString *)convertIBSIMessagePlaceholdersToString:(IBSIMessagePlaceholders)messagePlaceholders {
    NSString *result = nil;
    switch (messagePlaceholders) {
        case SENDER_NAME:
            result = @"SENDER_NAME";
            break;
        case RECEIVER_NAME:
            result = @"RECEIVER_NAME";
            break;
        case CUSTOM_TEXT:
            result = @"CUSTOM_TEXT";
            break;
        case END_USER_MSISDN:
            result = @"END_USER_MSISDN";
            break;
        case END_USER_USERNAME:
            result = @"END_USER_USERNAME";
            break;
        default:
            break;
    }
    
    return result;
}

@end
