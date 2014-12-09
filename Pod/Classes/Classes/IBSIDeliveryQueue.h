//
//  IBSIDeliveryQueue.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/29/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBSIDeliveryQueue : NSObject {
    NSOperationQueue *queue;
}
@property(nonatomic, retain) NSOperationQueue *queue;

+ (id)sharedInstance;

@end
