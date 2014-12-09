//
//  IBSIInvitationInfo.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/8/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBSIDeliveryStatus) {
    IBSIDeliveryStatusNotSet,
    IBSIDeliveryStatusUnknown,
    IBSIDeliveryStatusMessageWaiting,
    IBSIDeliveryStatusDeliveredToTerminal,
    IBSIDeliveryStatusDeliveryUncertain,
    IBSIDeliveryStatusDeliveryImpossible,
    IBSIDeliveryStatusDeleveredToNetwork,
    IBSIDeliveryStatusUndefined
};

@interface IBSIInvitationInfo : NSObject

@property NSString *msisdn;
@property NSInteger personId;
@property IBSIDeliveryStatus deliveryStatus;
@property NSString *bulkId;


- (IBSIInvitationInfo *)initWithMsisdn:(NSString *)msisdn personId:(NSInteger)personId;

- (IBSIInvitationInfo *)initWithMsisdn:(NSString *)msisdn personId:(NSInteger)personId bulkId:(NSString *)bulkId deliveryStatus:(NSString *)status;

- (NSString *)formattedMsisdn;

- (void)sendInviteWithDeliveryDelegate:(id)deliveryDelegate messageId:(NSString *)messageId;

- (void)requestDeliveryStatusInSeparateThreadWithDelegate:(id)delegate;

- (void)requestDeliveryStatusInSeparateThreadWithDelegate:(id)delegate atIndexPath:(NSIndexPath *)indexPath;

- (void)updateDeliveryStatus;

- (BOOL)inTerminalState;

- (BOOL)isInvited;

- (BOOL)isPending;

- (BOOL)isInImpossibleState;
@end
