//
//  IBSIEditMessageViewController.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 5/8/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "IBSIEditMessageViewController.h"
#import "InfobipSocialInvite.h"

@interface IBSIEditMessageViewController ()

@property(strong, nonatomic) IBOutlet UITextView *customMessageTextBox;
@property(strong, nonatomic) IBOutlet UILabel *charactersCount;
@property(strong, nonatomic) IBOutlet UITextView *defaultMessagePreview;

@end

@implementation IBSIEditMessageViewController
const int MESSAGE_TEXT_MAX_LENGTH = 132;
int customTextLength;

@synthesize customMessageTextBox = _customMessageTextBox;
@synthesize charactersCount = _charactersCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customMessageTextBox.delegate = self;
    if ([InfobipSocialInvite customMessageText] != nil) {
        self.customMessageTextBox.text = [InfobipSocialInvite customMessageText];
        self.defaultMessagePreview.text = [InfobipSocialInvite defaultMessageWithCustomText];
        self.charactersCount.text = [NSString stringWithFormat:@"%lu", (unsigned long) (MESSAGE_TEXT_MAX_LENGTH - [InfobipSocialInvite defaultMessageWithCustomText].length)];
        customTextLength = (int) (MESSAGE_TEXT_MAX_LENGTH - [InfobipSocialInvite defaultMessageWithCustomText].length);
    } else {
        self.defaultMessagePreview.text = [InfobipSocialInvite defaultMessageText];
        self.charactersCount.text = [NSString stringWithFormat:@"%lu", (unsigned long) (MESSAGE_TEXT_MAX_LENGTH - [[InfobipSocialInvite defaultMessageText] stringByReplacingOccurrencesOfString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:CUSTOM_TEXT] withString:@""].length)];
        customTextLength = (int) (MESSAGE_TEXT_MAX_LENGTH - [[InfobipSocialInvite defaultMessageText] stringByReplacingOccurrencesOfString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:CUSTOM_TEXT] withString:@""].length);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return textView.text.length + (text.length - range.length) <= customTextLength;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.defaultMessagePreview.text = [[InfobipSocialInvite defaultMessageText] stringByReplacingOccurrencesOfString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:CUSTOM_TEXT] withString:self.customMessageTextBox.text];
    self.charactersCount.text = [NSString stringWithFormat:@"%lu", (unsigned long) (MESSAGE_TEXT_MAX_LENGTH - (self.defaultMessagePreview.text.length))];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.customMessageTextBox resignFirstResponder];
}

/**
 Clicking on the Save button create message or if message already exist update message
 @author NKolarevic
 */
- (IBAction)saveBtn {
    [InfobipSocialInvite setCustomMessageText:self.customMessageTextBox.text];
    [InfobipSocialInvite setDefaultMessageWithCustomText:self.defaultMessagePreview.text];
    [self returnToFirst:self];
}

/**
 Clicking on the Reset button restore default message
 @author NKolarevic
 */

- (IBAction)setDefaultBtn {
    [InfobipSocialInvite setCustomMessageText:nil];
    [InfobipSocialInvite setDefaultMessageWithCustomText:nil];
    [self returnToFirst:self];
}

/**
 Return to IBSIContactsTableViewController
 
 @author NKolarevic
 @param (id)sender
 */
- (IBAction)returnToFirst:(id)sender {
    [self performSegueWithIdentifier:@"UnwindFromEditView" sender:self];
}

@end
