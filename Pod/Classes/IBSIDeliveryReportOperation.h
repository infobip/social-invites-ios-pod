//
//  IBSIDeliveryReportOperation.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/29/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSIPerson.h"

@protocol IBSIDeliveryReportDelegate;

@interface IBSIDeliveryReportOperation : NSOperation

@property(nonatomic, weak) id <IBSIDeliveryReportDelegate> delegate;
@property(nonatomic, readwrite) NSInteger numberOfRepeatings;
@property(nonatomic, readwrite) NSInteger pauseInSeconds;

@property(nonatomic, readonly, strong) IBSIPerson *person;
@property(nonatomic, readonly, strong) NSIndexPath *indexPath;

- (id)initWithPerson:(IBSIPerson *)person atIndexPath:(NSIndexPath *)indexPath delegate:(id <IBSIDeliveryReportDelegate>)theDelegate;

- (id)initWithPerson:(IBSIPerson *)person delegate:(id <IBSIDeliveryReportDelegate>)theDelegate;

@end


#pragma mark - Delegate
@protocol IBSIDeliveryReportDelegate <NSObject>

- (void)deliveryFetchDidFinish:(IBSIDeliveryReportOperation *)deliveryReport;

- (void)deliveryStatusDidChanged:(IBSIDeliveryReportOperation *)deliveryReport;

@end
