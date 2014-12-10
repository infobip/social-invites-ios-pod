//
//  IBSIContactCell.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 4/4/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "IBSIContactCell.h"

@implementation IBSIContactCell
@synthesize name = _name;
@synthesize inviteBtn = _inviteBtn;
@synthesize image = _image;
@synthesize statusImage = _statusImage;

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
    }
    return _name;
}

- (void)setName:(UILabel *)name {
    _name = name;
}

- (IBSIInviteButton *)inviteBtn {
    if (!_inviteBtn) {
        _inviteBtn = [[IBSIInviteButton alloc] init];
    }
    return _inviteBtn;
}

- (void)setInviteBtn:(IBSIInviteButton *)inviteBtn {
    _inviteBtn = inviteBtn;
}

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
    }
    return _image;
}

- (void)setImage:(UIImageView *)image {
    _image = image;
}


- (UIImageView *)statusImage {
    if (!_statusImage) {
        _statusImage = [[UIImageView alloc] init];
    }
    return _statusImage;
}

- (void)setStatusImage:(UIImageView *)statusImage {
    _statusImage = statusImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
