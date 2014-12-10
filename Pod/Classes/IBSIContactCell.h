//
//  IBSIContactCell.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/4/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBSIInviteButton.h"

@interface IBSIContactCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *image;
@property(strong, nonatomic) IBOutlet UILabel *name;
@property(strong, nonatomic) IBOutlet IBSIInviteButton *inviteBtn;
@property(strong, nonatomic) IBOutlet UIImageView *statusImage;


@end
