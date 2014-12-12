# Infobip Social Invites library for iOS #

This project is an iOS library which can be merged with your iOS project and enables you to use the Infobip Social Invites service.

##Installation 

Install SocialInvites with [Cocoapods](http://cocoapods.org/). Just paste next code snippet to Podfile:

	pod 'SocialInvite'
	

**If you use *Cocoapods* you can skip following block**

```

## Requirements ##

Include the following files to your project:

    libInfobipSocialInvite.a
    InfobipSocialInvite.h
    ResouresCore.bundle
    
- Check is the `.a` file added to `Build Phases -> Link Binary With Libraries`
- Check is the `.bundle` file added to `Build Phases -> Copy Bundle Resources`

### Include frameworks

Include the following frameworks into your project:

    AddressBook.framework
    UIKit.framework
    SystemConfiguration.framework
    MobileCoreServices.framework
    QuartzCore.framework
    CoreData.framework
    CoreTelephony.framework
    CoreGraphics.framework

### Linking library to the Application

Since Objective-C generates only one symbol per class we must also force the linker to load the members of the class by using the -ObjC flag. We also must to force an inclusion of all our objects from our static library by adding the -all_load linker flag. If you skip these flags (sooner or later) you will run into the unrecognised selector error or get other exceptions such as the one observed here.

In the Application target under `Build setting -> Linking -> Other Linker Flags` add the following flags 

- `-ObjC`
- `-all_load`

```


## Application registration

In order to use the Social invites library you first have to create an Infobip account ([http://infobip.com/sign_up/](http://infobip.com/sign_up/ "Infobip sign up")) and register your [Mobile application](http://developer.infobip.com/api#!/SocialInvite/GET_1_social_invite_application). After the application registration you will obtain the **application key** and **application secret key**. 

The next step is creating a default message for your application after which you will obtain the **default message ID**.

## Initialization

Initialization is required for using main functionality of the library - sending social invitations. 
For library initialization simple call one of the following methods:

       [initWithApplicationKey:APPLICATION_KEY secretKey:SECRET_KEY defaultMessageId:DEFAULT_MESSAGE_ID];
                          
       [initWithApplicationKey:APPLICATION_KEY secretKey:SECRET_KEY defaultMessageId:DEFAULT_MESSAGE_ID clientListForPlaceholder:CLIENT_LIST_FOR_PLACEHOLDERS];

This methods use your Infobip application key, secret key and default message id for your application, all method's parameters are type of string. 
If your default message text contains client placeholders you have to use the second method (with client list for placeholders) for initialization. Client list for placeholders represents array of strings which will be used to populate your client placeholders in default message respectively.In client list for placeholders  it is possible to use predefined values from **IBSIMessagePlaceholders** enum:
	
- RECEIVER_NAME: Assigns name of contact, to which user sends social invitation, fetched from user's phonebook. 
- SENDER_NAME: Assigns defined sender id for application. Note that you have to provide sender id (see the next chapter);
- CUSTOM_TEXT: With this value for placeholder defined in a list you give possibilty to end users to write their own part of message. 
- END USER_MSISDN: Assigns end user phone number to placeholder. Note that you have to provide end users phone number after initialization of library. Provide phone number by calling `+ (void)setEndUserMsisdn:(NSString *)msisdn` method from **InfobipSocialInvite**;
- END USER_USERNAME: Assigns end user username to placeholder.  You have to provide end user username by calling `+ (void)setEndUserUsername:(NSString *)username`  method from **InfobipSocialInvite** after initialization of library.

Also it is possible to add custom value for placeholder but remember that a number of parameters in client list for placeholders must match the number of client placeholders in your default message otherwise you will receive *Invalid parameters* error.

Example of usage:

    NSArray * clientList = [NSArray arrayWithObjects:@"Your_text",@"SENDER_NAME",@"END_USER_MSISDN", nil];
        [InfobipSocialInvite initWithApplicationKey:@"Your_app_key"
                                          secretKey:@"Your_secret_key"
                                          defaultMessageId:@"Your_default_message_id"
                                          clientListForPlaceholders:clientList];
                                
                    [InfobipSocialInvite setSenderId:@"Your_sender_id"];
                    [InfobipSocialInvite setEndUserMsisdn:@"Your_end_user_msisdn"];


In every moment you can check if library is initialized by calling method `(BOOL)isLibraryInitialized` from **InfobipSocialInvite** class, which return **true** value if library is initialized or **false** if it is not.
                        
## Sender ID

The sender ID could either be a numeric (e.g. user's MSISDN - phone number) or some alphanumeric. If you decide to set the sender ID you have to take care of its length – the max length for alphanumeric sender ID is 11 characters and 16 for numeric senders. The method used for setting the sender ID is `(void)setSenderId:(NSString *)senderId`.

Usage example:
    
    //numeric sender id
    [InfobipSocialInvite setSenderId:@"your_phone_number"];
    //alphanumeric sender id
    [InfobipSocialInvite setSenderId:@"your_name"];
    
Once you set the sender ID, you can use the `(NSString *)senderId` method to find out the string representation of the sender ID. 

Usage example:

    String senderId = [InfobipSocialInvite senderId];
    
## Invitation message

As mentioned above, after application registration, you have to add default message for your application. This default message is invitation message for your application. The social invite message text will be the text of your default message with the placeholder for your hyperlink and optional with client placeholder for custom parts in your default message.  Everytime a user sends invitation, text of message will be text of default message with hyperlink included.	
If you want, you can give possibility to users to send personalize text which will be included in your default message(by calling `(void)setMessageEditing:(BOOL)edit` method from **InfobipSocialInvite**). In that case, client text will be set instead *CUSTOM_TEXT* in your client list for placeholder and  hyperlink will be set instead placeholder for url in your default message. All you have to do is to enable edit message. 
If editing message is enabled, the message line will be shown in the bottom of contacts table view. That line contains message text that will be sent and pen icon. Clicking on the line opens edit message dialog where user can customize his invitation message. User has option to reset default message with custom text to default message without custom text. If the user click save button default message with his custum text will be sent to his contact until he reset message to default. By default, your default message is used.

![](http://www.infobip.com/images/demo/iOSEditMessage.png)

**Warning:** If you allow users to change the message remember that the user can send a message with content which you can not approve or uses this functionality to other purposes (e.g. if both edit message and message resending are enabled).
 
## User's contacts list

In order to allow your users to send invitations to their contacts you have to include the table view containing all the contacts from the user’s address book. To do that you have to call the following method:

    (void)startSocialInviteView:(UIViewController *)viewContoller 
                               block:(void(^)())block;

The contacts table view contains a list of all the contacts from the user's address book. If a contact has his picture stored on the user's device, the same picture will be shown in the list. If he doesn't, that place will be taken by a default image.

![](http://www.infobip.com/images/demo/iOSContacsList.png)

For contacts with more than one phone number, the overall number of the phone numbers is presented in the brackets next to the Invite button. When a user clicks on a contact, all numbers are shown in dropdown list. The user can choose if he wants to invite his friends by sending the invitations only to one phone number or to all contact numbers at the same time.

![](http://www.infobip.com/images/demo/iOSContactsSearch.png)

If the user tries to the send the invitation when he does not have an active Internet connection a dialog box warning for a lack of data connection will be displayed.
    
## Sending an invite 

After you have included the contacts table view, the user simply has to click on the ***invite*** button next to the contact he wants to invite. In case a contact has more than one number the user can send the invite to all numbers by clicking on the ***invite*** button.

![](http://www.infobip.com/images/demo/iOSSendingStatus.png)

If he wants to choose one number, he has to click on the contact and to get a list of the numbers. By clicking on any number from the list, the invitation message will be sent only to that specific number.

![](http://www.infobip.com/images/demo/iOSMultipleContactNumbers.png)

## Message resending

You also have a control over the number of invitations that a user can send to one phone number. If you want to let your user send the invitation to one phone number more than once you have to enable invitation resending. You can do that by calling the `[InfobipSocialInvite setSocialInviteResending:true]`method. 

If you want your user to only be able to send one invitation to one phone number, you should call the previous method with the ***false*** `[InfobipSocialInvite setSocialInviteResending:false]`parameter. This is disabled by default.

## Delivery status ##

When a user sends the invitation, he may want to see its delivery status. The delivery status icon is shown in the front of every invited phone number and over the contact's image. This way the user has all the information he needs.

There are three possible states of an invitation message: 

- **Delivered** - if the message has been delivered to the invited phone number
- **Failed** - if the message has failed to be delivered to the invited phone number or if the phone number is invalid,
- **Pending** - if the message has no terminal status as of yet.

![](http://www.infobip.com/images/demo/iOSSendingStatus.png)

Every time a user opens the contacts table view, the delivery status checking (for pending phone numbers) starts.

## Infobip Social Invites delegate

The majority of these functionalities uses an http requests such as “GET”, “POST” or “PUT”. This request can return “error” as a response. If you want to handle these errors and be notified when an error occurs, you can use the delegate **InfobipSocialInviteDelegate**.

To use this delegate, add it in your class .h file like this:
    
    #import "InfobipSocialInvite.h"
    @interface YourClassName: NSObject <InfobipSocialInviteDelegate>
    
This means that the “YourClassName” class is a subclass of NSObject (or another class) and conforms to the InfobipSocialInviteDelegate protocol.

Delegate protocols exist so that you can make sure that the delegate object has the necessary methods to deal with your messages. Methods in the delegate protocol can be optional or enforced. Any methods that are optional don't have to be defined. All the methods in **InfobipSocialInviteDelegate** are optional so you can freely choose which one to use.

If you want to include your code when sent invites return an error, define the method `-(void)sendInviteDidReceiveErrorResponse:(NSError *)error` in your class include your code in its body. To work with a successful response for sent invites use the `-(void)sendInviteDidReceiveSuccessfulResponse:(SendSmsResponse *)response` delegate method.

For the delivery status error define the `-(void)getDeliveryInfoDidReceiveErrorResponse:(NSError *)error`method. For a successful response use the `-(void)getDeliveryInfoDidReceiveSuccessfulResponse:(SocialInviteDelivery *)response` method.

“Edit message” can get the default message so you can use the following method to get an error:  `-(void)getMessageDidReceiveErrorResponse:(NSError *)error`. For a successful response use: `-(void)getMessageDidReceiveSuccessfulResponse:(ClientMobileApplicationMessageResponse *)response`.

## Owners

Framework Integration Team @ Infobip Belgrade, Serbia

*IOS is a trademark of Cisco in the U.S. and other countries and is used under license.*

© 2014, Infobip Ltd.
