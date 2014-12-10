//
//  IBSIContactsTableViewController.h
//  InfobipSocialInvite
//
//  Created by MMiroslav on 3/25/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBSIDeliveryReportOperation.h"
#import "InfobipSocialInvite.h"


@interface IBSIContactsTableViewController : UITableViewController <UIActionSheetDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate, IBSIDeliveryReportDelegate, InfobipSocialInviteDelegate> {

}
@property(strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
