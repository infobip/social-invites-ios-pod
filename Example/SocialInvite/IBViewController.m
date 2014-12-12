//
//  IBViewController.m
//  SocialInvite
//
//  Created by Miroslav Milivojevic on 12/09/2014.
//  Copyright (c) 2014 Miroslav Milivojevic. All rights reserved.
//

#import "IBViewController.h"
#import <InfobipSocialInvite.h>

@interface IBViewController ()

@end

@implementation IBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)siBtn:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [InfobipSocialInvite startSocialInviteView:self block:^{
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }];
    
}



- (void)setupSI
{
//    if ([InfobipSocialInvite isLibraryInitialized]) {
        [InfobipSocialInvite initWithApplicationKey:@"DF11421F70EB7ED882C294C890E7C4EF"
                                          secretKey:@"573711510e1c002e29679b12c7cb48ae-abb7de3b-f56e-4d1c-b7ed-c5c6058bb679"
                                   defaultMessageId:@"AAAF082A7C8F39F8A7E14AD2DE84CBEE"
                          clientListForPlaceholders:[NSArray arrayWithObjects:@"NEVENU",@"SENDER_NAME",@"CUSTOM_TEXT", nil]];
        
        [InfobipSocialInvite setSenderId:@"MMM"];
        [InfobipSocialInvite setMessageEditing:YES];
//    }
}
@end
