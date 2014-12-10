//
//  IBSIContactsTableViewController.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 3/25/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "AddressBook.h"
#import "IBSIContactsTableViewController.h"
#import "IBSIContactCell.h"
#import "IBSIUtils.h"
#import "IBSIAddressBook.h"

#import "IBSIInvite.h"

#define INVITATION_STATUS_ICON_INVITED @"Resources.bundle/invited.png"
#define INVITATION_STATUS_ICON_PENDING @"Resources.bundle/pending.png"
#define INVITATION_STATUS_ICON_FAILED @"Resources.bundle/impossible.png"
#define IBSI_STORYBOARD_NAME @"IBSIStoryboard"

@interface IBSIContactsTableViewController ()

@property(nonatomic, strong) NSArray *people;
@property(nonatomic, strong) NSMutableArray *result;

@property(strong, nonatomic) IBOutlet UIBarButtonItem *editMessage;

@end

@implementation IBSIContactsTableViewController
IBSIPerson *actionSheetPerson = nil;

@synthesize result = _result;
@synthesize people = _people;
@synthesize searchBar = _searchBar;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (([IBSIAddressBook authorizationStatus] == IBSIAuthorizationStatusNotDetermined)) {
        [[InfobipSocialInvite addressBook] requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            if (granted) {
                // First time access has been granted, add the contact
                self.people = [[InfobipSocialInvite addressBook] peopleOrderedByFirstName];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:false];
            } else {
                // User denied access
                UIAlertView *alert = [self addAlert];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:false];
            }
        }];
    } else if ([IBSIAddressBook authorizationStatus] == IBSIAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        self.people = [[InfobipSocialInvite addressBook] peopleOrderedByFirstName];
    }
    else {
        // The user has previously denied access
        UIAlertView *alert = [self addAlert];
        [alert show];
    }
    [InfobipSocialInvite setDelegate:self];
    
    
    // Message editing
    if ([InfobipSocialInvite messageEditing]) {
        __block IBSIContactsTableViewController *blockSelf = self;
        
        [InfobipSocialInvite getMessageByMessageId:[InfobipSocialInvite defaultMessageId] withSuccessBlock:^(ClientMobileApplicationMessageResponse *messageResponse) {
            [blockSelf setMessageTextWithResponse:messageResponse];
            if ([InfobipSocialInvite defaultMessageWithCustomText] == nil) {
                blockSelf.editMessage.title = [NSString stringWithFormat:@"✍ %@", [InfobipSocialInvite defaultMessageText]];
            } else {
                blockSelf.editMessage.title = [NSString stringWithFormat:@"✍ %@", [InfobipSocialInvite defaultMessageWithCustomText]];
            }
            blockSelf.navigationController.toolbarHidden = NO;
        } failureBlock:^(NSError *error) {
            [InfobipSocialInvite getMessageByMessageId:[InfobipSocialInvite defaultMessageId] withSuccessBlock:^(ClientMobileApplicationMessageResponse *messageResponse) {
                [blockSelf setMessageTextWithResponse:messageResponse];
                if ([InfobipSocialInvite defaultMessageWithCustomText] == nil) {
                    blockSelf.editMessage.title = [NSString stringWithFormat:@"✍ %@", [InfobipSocialInvite defaultMessageText]];
                } else {
                    blockSelf.editMessage.title = [NSString stringWithFormat:@"✍ %@", [InfobipSocialInvite defaultMessageWithCustomText]];
                }
                blockSelf.navigationController.toolbarHidden = NO;
            } failureBlock:^(NSError *error) {
                if ([InfobipSocialInvite defaultMessageText] != nil) {
                    if ([InfobipSocialInvite defaultMessageWithCustomText] == nil) {
                        blockSelf.editMessage.title = [NSString stringWithFormat:@"✍ %@", [InfobipSocialInvite defaultMessageText]];
                    } else {
                        blockSelf.editMessage.title = [NSString stringWithFormat:@"✍ %@", [InfobipSocialInvite defaultMessageWithCustomText]];
                    }
                    blockSelf.navigationController.toolbarHidden = NO;
                }
            }];
        }];
    }
    
    [[InfobipSocialInvite addressBook] requestDeliveryStatusAndUpdatePendingInvitationsWithDelegate:self];
    // Checking internet connection
    if (![IBSIUtils checkIsInternetConnectionReachable]) {
        UIAlertView *internetAlert = [[UIAlertView alloc] initWithTitle:@"Internet Unreachable"
                                                                message:@"Internet connection is unreachable"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
        [internetAlert show];
        NSLog(@"Problem with Internet connection");
    }
}

- (void)setMessageTextWithResponse:(ClientMobileApplicationMessageResponse *)messageResponse {
    NSString *text = [messageResponse.text stringByReplacingOccurrencesOfString:messageResponse.placeholder withString:@""];
    [InfobipSocialInvite setClientPlaceholder:messageResponse.clientPlaceholder];
    
    if (text != NULL) {
        for (NSString *object in [InfobipSocialInvite clientListForPlaceholders]) {
            NSRange range;
            if([object isEqualToString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:SENDER_NAME]]){
                range = [text rangeOfString:[InfobipSocialInvite clientPlaceholder]];
                NSAssert(range.length!=0,@"Client placeholder not found!");
                NSAssert([InfobipSocialInvite senderId], @"Sender id is nil!");
                text = [text stringByReplacingCharactersInRange:range withString:[InfobipSocialInvite senderId]];
            }else if ([object isEqualToString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:END_USER_MSISDN]]){
                range = [text rangeOfString:[InfobipSocialInvite clientPlaceholder]];
                NSAssert(range.length!=0,@"Client placeholder not found!");
                NSAssert([InfobipSocialInvite endUserMsisdn], @"End user msisdn is nil!");
                text = [text stringByReplacingCharactersInRange:range withString:[InfobipSocialInvite endUserMsisdn]];
            }else if ([object isEqualToString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:END_USER_USERNAME]]){
                range = [text rangeOfString:[InfobipSocialInvite clientPlaceholder]];
                NSAssert(range.length!=0,@"Client placeholder not found!");
                NSAssert([InfobipSocialInvite endUserUsername], @"End user username is nil!");
                text = [text stringByReplacingCharactersInRange:range withString:[InfobipSocialInvite endUserUsername]];
            }else{
                range = [text rangeOfString:[InfobipSocialInvite clientPlaceholder]];
                NSAssert(range.length!=0, @"Client placeholder not found!");
                text = [text stringByReplacingCharactersInRange:range withString:object];
            }
        }
        
        [InfobipSocialInvite setDefaultMessageText:text];
        if ([InfobipSocialInvite customMessageText] != nil) {
            [InfobipSocialInvite setDefaultMessageWithCustomText:[[InfobipSocialInvite defaultMessageText] stringByReplacingOccurrencesOfString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:CUSTOM_TEXT] withString:[InfobipSocialInvite customMessageText]]];
        }
    }
}

#pragma mark - Alert

/**
 Address book authorization alert
 
 @author NKolarevic
 @return (UIAlertView *) - return alert view
 */
- (UIAlertView *)addAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"InfobipSocialInvite"
                                                    message:@"To send invites you must allow InfobipSocialInvite acces to your AddressBook. Go to Settings/Privacy/Contacts to enable acces."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    return alert;
    
}

/**
 Action for clicked button.
 Return to the demo app view when OK button is clicked.
 
 @author NKolarevic
 @param (UIAlertView)alertView
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //Code for ok button
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"Returning to app");
        }];
    }
}

#pragma mark - Search
/**
 Search throw contacts in address book.
 
 @author NKolarevic
 */
- (void)searchThrowContacts {
    self.result = nil;
    self.result = [[InfobipSocialInvite addressBook] searchThroughPeople:self.people withText:self.searchBar.text];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self searchThrowContacts];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.result count];
    } else {
        return [self.people count];
    }
}

// return to application Storyboard
- (IBAction)DoneBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Returning to app");
    }];
}

/**
 Invitation button text
 
 @param (IBSIPerson) person
 @author MMiroslav
 @return (NSString) button text
 */
- (NSString *)inviteBtnText:(IBSIPerson *)person {
    NSInteger addressesCount = [person numberOfNonInvitedMsisdns];
    if ([InfobipSocialInvite socialInviteResending]) {
        addressesCount = [person.invitationInfos count];
    }
    if (addressesCount > 1) {
        return [NSString stringWithFormat:@"Invite (%d)", (int) addressesCount];
    }
    return @"Invite";
}

/**
 Setting invitation button text and state according to person delivery status
 
 @author MMiroslav
 @param (IBSIInviteButton) btn button to set details
 @param (IBSIPerson) person
 @return (IBSIInviteButton) return prepared button
 */
- (IBSIInviteButton *)inviteButton:(IBSIInviteButton *)btn forPerson:(IBSIPerson *)person {
    [btn setEnabled:YES];
    [btn setButtonId:(NSInteger) person.personId];
    [btn setTitle:[self inviteBtnText:person] forState:UIControlStateNormal];
    
    if (![InfobipSocialInvite socialInviteResending] && person.isInvited) {
        [btn setTitle:@"Invited" forState:UIControlStateNormal];
        [btn setEnabled:NO];
    }
    if (person.isInPendingState) {
        [btn setTitle:@"Pending..." forState:UIControlStateNormal];
        [btn setEnabled:NO];
    }
    
    return btn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IBSIPerson *person = nil;
    static NSString *CellIdentifier = @"ContactCell";
    IBSIContactCell *cell = (IBSIContactCell *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    
    // Configure the cell
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        person = [self.result objectAtIndex:(NSUInteger) indexPath.row];
    } else {
        person = [self.people objectAtIndex:(NSUInteger) indexPath.row];
    }
    cell.name.text = person.name;
    cell.image.image = (person.thumbnail != nil) ? person.thumbnail : [UIImage imageNamed:@"Resources.bundle/userNew.png"];
    if ([InfobipSocialInvite deliveryReportEnable]) {
        cell.statusImage.image = [self imageForInvitationStatus:person.deliveryStatus];
    }
    
    // Configure invite button
    [self inviteButton:cell.inviteBtn forPerson:person];
    
    return cell;
}

/**
 Returns invitation status image according to invitation status
 
 @author MMiroslav
 @param (NSString) status
 @return (UIImage) image
 */
- (UIImage *)imageForInvitationStatus:(IBSIDeliveryStatus)status {
    UIImage *image = nil;
    switch (status) {
        case IBSIDeliveryStatusNotSet:
            image = nil;
            break;
        case IBSIDeliveryStatusDeleveredToNetwork:
        case IBSIDeliveryStatusDeliveredToTerminal:
        case IBSIDeliveryStatusDeliveryUncertain:
            image = [UIImage imageNamed:INVITATION_STATUS_ICON_INVITED];
            break;
        case IBSIDeliveryStatusDeliveryImpossible:
            image = [UIImage imageNamed:INVITATION_STATUS_ICON_FAILED];
            break;
        case IBSIDeliveryStatusMessageWaiting:
        case IBSIDeliveryStatusUnknown:
            image = [UIImage imageNamed:INVITATION_STATUS_ICON_PENDING];
            break;
        default:
            image = nil;
            break;
    }
    return image;
}

# pragma mark - Invite

/**
 Send social invite for all phone numbers for one person when button is clicked.
 
 @author NKolarevic
 @param  (IBSIInviteButton)sender
 @return (IBAction)
 */
- (IBAction)sendInviteToAllMsisdns:(IBSIInviteButton *)sender {
    NSLog(@"Button id: %ld", (long) sender.buttonId);
    IBSIPerson *person = [[InfobipSocialInvite addressBook] personWithId:(ABRecordID) sender.buttonId];
    [person sendInviteWithDeliveryDelegate:self messageId:[InfobipSocialInvite defaultMessageId]];
    
    [self.tableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - ActionSheet
/**
 Action sheet for display phone numbers for one contact
 
 @author NKolarevic
 @param (UIActionSheet)actionSheet
 @param (NSInteger)buttonIndex
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger cancelButtonIndex = [actionSheet cancelButtonIndex];
    NSInteger sendToAllButtonIndex = cancelButtonIndex - 1;
    if (buttonIndex == sendToAllButtonIndex) {
        [actionSheetPerson sendInviteWithDeliveryDelegate:self messageId:[InfobipSocialInvite defaultMessageId]];
        
    } else if (buttonIndex != cancelButtonIndex) {
        [[actionSheetPerson.invitationInfos objectAtIndex:buttonIndex] sendInviteWithDeliveryDelegate:self messageId:[InfobipSocialInvite defaultMessageId]];
    }
    
    [self.tableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

/**
 Action sheet for display all phone numbers for one contact
 
 @param person (IBSIPerson)
 @author MMiroslav
 */
- (void)showActionSheetForPerson:(IBSIPerson *)person {
    UIActionSheet *numbersActionSheet = [[UIActionSheet alloc] init];
    numbersActionSheet.title = @"Contact numbers";
    numbersActionSheet.delegate = self;
    
    for (IBSIInvitationInfo *info in person.invitationInfos) {
        NSString *itemTitle = @"";
        if ([info isInvited]) {
            itemTitle = [NSString stringWithFormat:@"✅ %@", info.msisdn];
        } else if ([info isPending]) {
            itemTitle = [NSString stringWithFormat:@"⏳ %@", info.msisdn];
        } else if ([info isInImpossibleState]) {
            itemTitle = [NSString stringWithFormat:@"🚫 %@", info.msisdn];
        } else {
            itemTitle = [NSString stringWithFormat:@"%@", info.msisdn];
        }
        [numbersActionSheet addButtonWithTitle:itemTitle];
    }
    
    [numbersActionSheet addButtonWithTitle:@"Send to all"];
    [numbersActionSheet setCancelButtonIndex:[numbersActionSheet addButtonWithTitle:@"Cancel"]];
    
    [numbersActionSheet showInView:self.view];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Contact row is: %ld", (long) indexPath.row);
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        actionSheetPerson = [self.result objectAtIndex:indexPath.row];
    } else {
        actionSheetPerson = [self.people objectAtIndex:indexPath.row];
    }
    
    [self showActionSheetForPerson:actionSheetPerson];
}

#pragma mark - Delivery Delegate

- (void)deliveryFetchDidFinish:(IBSIDeliveryReportOperation *)deliveryReport {
    [self.tableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)deliveryStatusDidChanged:(IBSIDeliveryReportOperation *)deliveryReport {
    UITableView *tv = self.tableView;
    //    if (NO) {
    //        tv = self.searchDisplayController.searchResultsTableView;
    //        [self searchThrowContacts];
    //    } else {
    tv = self.tableView;
    //    }
    
    // if indexPath is set reload row at that indexPath
    // otherwise reload all rows
    if (deliveryReport.indexPath) {
        [tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:deliveryReport.indexPath]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [tv reloadData];
    }
}

#pragma mark - Edit message

/**
 Return from IBSIEditMessageViewController
 
 @author NKolarevic
 @param (UIStoryboardSegue)segue
 */
- (IBAction)returnedFromSegue:(UIStoryboardSegue *)segue {
    if ([InfobipSocialInvite defaultMessageWithCustomText] != nil) {
        self.editMessage.title = [NSString stringWithFormat:@"✍ %@", [InfobipSocialInvite defaultMessageWithCustomText]];
    } else {
        self.editMessage.title = [NSString stringWithFormat:@"✍ %@", [InfobipSocialInvite defaultMessageText]];
    }
}

#pragma mark - InfobipSocialInviteDelegate

- (void)sendInviteDidReceiveResponseWithError:(NSError *)error {
    NSLog(@"Send invite receive error: %@", [error localizedDescription]);
}

- (void)createMessageDidReceiveResponseWithError:(NSError *)error {
    NSLog(@"Create message  receive error: %@", [error localizedDescription]);
}

- (void)getMessageDidReceiveResponseWithError:(NSError *)error {
    NSLog(@"Get message receive error: %@", [error localizedDescription]);
}

- (void)updateMessageDidReceiveResponseWithError:(NSError *)error {
    NSLog(@"Update message receive error: %@", [error localizedDescription]);
}

- (void)getDeliveryInfoDidReceiveResponseWithError:(NSError *)error {
    NSLog(@"Get delivery info recive error: %@", [error localizedDescription]);
}

- (void)sendInviteDidReceiveSuccessfulResponse:(SendSmsResponse *)response {
    NSLog(@"Send invite receive successfull response: %@", response);
}

- (void)createMessageDidReceiveSuccessfulResponse:(ClientMobileApplicationMessageResponse *)response {
    NSLog(@"Create message receive successfull response: %@", response);
}

- (void)updateMessageDidReceiveSuccessfulResponse:(ClientMobileApplicationMessageResponse *)response {
    NSLog(@"Update message receive successfull response: %@", response);
}

- (void)getMessageDidReceiveSuccessfulResponse:(ClientMobileApplicationMessageResponse *)response {
    NSLog(@"Get message receive successfull response: %@", response);
}

- (void)getDeliveryInfoDidReceiveSuccessfulResponse:(SocialInviteDelivery *)response {
    NSLog(@"Get delivery info receive successful response: %@", response);
}

@end
