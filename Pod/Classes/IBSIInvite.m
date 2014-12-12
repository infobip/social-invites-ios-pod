//
//  IBSIInvite.m
//  InfobipSocialInvite
//
//  Created by MMiroslav on 3/13/14.
//  Copyright (c) 2014 Infobip. All rights reserved.
//

#import "InfobipSocialInvite.h"
#import "IBSIInvite.h"
#import "IBSIInvitationInfo.h"
#import "IBSIPerson.h"
#import "Models/SmsMessageResponse.h"
#import "Models/SocialInviteRequest.h"
#import "Models/Recipient.h"
#import "Models/Destinations.h"
#import "Models/DeliveryInfo.h"
#import "Models/SocialInviteDelivery.h"
#import "Models/ClientMobileApplicationMessageRequest.h"
#import "Models/ClientMobileApplicationMessageResponse.h"
#import "IBSIUtils.h"
#import "Consts.h"
#import "IBSIAddressBook.h"

#define IBSI_BUNDLE_NAME @"Resources"
#define IBSI_BUNDLE_TYPE @"bundle"
#define IBSI_MODEL_NAME  @"Model"
#define IBSI_MODEL_TYPE  @"momd"
#define IBSI_PERSISTENT_STORE @"SocialInvite.sqlite"
#define IBSI_STORYBOARD_NAME @"IBSIStoryboard"

#define IBSI_PATH_SEND_INVITE @"1/social-invite/invitation"
#define IBSI_PATH_MESSAGE @"1/social-invite/application/%@/message/%@"
#define IBSI_PATH_DELIVERY_REPORT @"1/smsmessaging/outbound/requests/%@/deliveryInfos"

@implementation IBSIInvite

#pragma mark - RestKit SetUp

static RKObjectManager *objectManager;

+ (void)setupRestKit {
    
    RKLogConfigureByName("*", RKLogLevelTrace); // set all logs to trace,
    RKLogConfigureByName("RestKit*", RKLogLevelTrace);
    
    objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:IBSI_BASE_URL]];
    
    [[objectManager HTTPClient] setDefaultHeader:@"Content-Type" value:@"application/json"];
    [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    // getting resources bundle with model schema
    NSString *modelPath = [[IBSIUtils libraryBundle] pathForResource:IBSI_MODEL_NAME ofType:IBSI_MODEL_TYPE];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    NSManagedObjectModel *manageModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // RestKit object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:manageModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    [managedObjectStore createPersistentStoreCoordinator];
    
    // persistent store
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:IBSI_PERSISTENT_STORE];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                                                     fromSeedDatabaseAtPath:nil
                                                                          withConfiguration:nil
                                                                                    options:@{NSMigratePersistentStoresAutomaticallyOption : @YES,
                                                                                              NSInferMappingModelAutomaticallyOption : @YES}
                                                                                      error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    [managedObjectStore createManagedObjectContexts];
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    // cache
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    // error mapping
    [self errorMapping];
    
    // entity mapping
    [self entityMapping];
}

#pragma mark - Error Mapping

+ (void)errorMapping {
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                         method:RKRequestMethodAny
                                                                                    pathPattern:nil
                                                                                        keyPath:@"requestError.serviceException.text"
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [objectManager addResponseDescriptorsFromArray:@[errorDescriptor]];
}

#pragma mark - Entity Mapping

+ (void)entityMapping {
    // entity mapping
    RKEntityMapping *socialInviteRequestMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([SocialInviteRequest class])
                                                                      inManagedObjectStore:objectManager.managedObjectStore];
    [socialInviteRequestMapping addAttributeMappingsFromArray:@[@"messageKey", @"sender"]];
    
    RKEntityMapping *destinationsMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Destinations class])
                                                               inManagedObjectStore:objectManager.managedObjectStore];
    [destinationsMapping addAttributeMappingsFromDictionary:@{@"address" : @"address"}];
    [destinationsMapping addAttributeMappingsFromDictionary:@{@"messageId" : @"messageId"}];
    [destinationsMapping addAttributeMappingsFromDictionary:@{@"clientData" : @"clientData"}];
    
    
    RKEntityMapping *socialInviteDeliveryMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([SocialInviteDelivery class])
                                                                       inManagedObjectStore:objectManager.managedObjectStore];
    [socialInviteDeliveryMapping addAttributeMappingsFromArray:@[@"resourceURL"]];
    socialInviteDeliveryMapping.identificationAttributes = @[@"resourceURL"];
    
    RKEntityMapping *deliveryInfoMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([DeliveryInfo class])
                                                               inManagedObjectStore:objectManager.managedObjectStore];
    [deliveryInfoMapping addAttributeMappingsFromArray:@[@"address", @"messageId", @"deliveryStatus", @"clientCorrelator", @"price"]];
    deliveryInfoMapping.identificationAttributes = @[@"address"];
    
    RKEntityMapping *recipientsMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Recipient class])
                                                             inManagedObjectStore:objectManager.managedObjectStore];
    RKEntityMapping *clientMobileApplicationMessageRequestMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([ClientMobileApplicationMessageRequest class])
                                                                                        inManagedObjectStore:objectManager.managedObjectStore];
    [clientMobileApplicationMessageRequestMapping addAttributeMappingsFromArray:@[@"placeholder", @"text", @"clientPlaceholder"]];
    RKEntityMapping *clientMobileApplicationMessageResponseMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([ClientMobileApplicationMessageResponse class])
                                                                                         inManagedObjectStore:objectManager.managedObjectStore];
    [clientMobileApplicationMessageResponseMapping addAttributeMappingsFromArray:@[@"placeholder", @"text", @"key", @"clientMobileApplicationKey", @"clientPlaceholder"]];
    
    // relation mapping request
    [recipientsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"destinations"
                                                                                      toKeyPath:@"destinations"
                                                                                    withMapping:destinationsMapping]];
    [socialInviteRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recipients"
                                                                                               toKeyPath:@"recipients"
                                                                                             withMapping:recipientsMapping]];
    
    
    RKEntityMapping *sendSmsResponseMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([SendSmsResponse class])
                                                                  inManagedObjectStore:objectManager.managedObjectStore];
    [sendSmsResponseMapping addAttributeMappingsFromArray:@[@"deliveryInfoUrl", @"bulkId"]];
    RKEntityMapping *smsMessageResponsesMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([SmsMessageResponse class])
                                                                      inManagedObjectStore:objectManager.managedObjectStore];
    [smsMessageResponsesMapping addAttributeMappingsFromArray:@[@"messageId", @"status", @"price"]];
    
    // relation mapping response
    [sendSmsResponseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"responses"
                                                                                           toKeyPath:@"responses"
                                                                                         withMapping:smsMessageResponsesMapping]];
    [socialInviteDeliveryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"deliveryInfo"
                                                                                                toKeyPath:@"deliveryInfo"
                                                                                              withMapping:deliveryInfoMapping]];
    
    
    // decriptors
    RKRequestDescriptor *sendInviteRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[socialInviteRequestMapping inverseMapping]
                                                                                             objectClass:[SocialInviteRequest class]
                                                                                             rootKeyPath:nil
                                                                                                  method:RKRequestMethodAny];
    RKResponseDescriptor *sendInviteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:sendSmsResponseMapping
                                                                                                      method:RKRequestMethodPOST
                                                                                                 pathPattern:nil
                                                                                                     keyPath:@"sendSmsResponse"
                                                                                                 statusCodes:[NSIndexSet indexSetWithIndex:200]];
    RKResponseDescriptor *inviteDeliveryResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:socialInviteDeliveryMapping
                                                                                                          method:RKRequestMethodGET 
                                                                                                     pathPattern:nil
                                                                                                         keyPath:@"deliveryInfoList"
                                                                                                     statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *getMessageDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:clientMobileApplicationMessageResponseMapping
                                                                                              method:RKRequestMethodGET
                                                                                         pathPattern:nil
                                                                                             keyPath:nil
                                                                                         statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // add descriptors
    [objectManager addRequestDescriptor:sendInviteRequestDescriptor];
    [objectManager addResponseDescriptor:sendInviteResponseDescriptor];
    [objectManager addResponseDescriptor:inviteDeliveryResponseDescriptor];
    [objectManager addResponseDescriptor:getMessageDescriptor];
    
    
}

#pragma mark - Authorization

+ (void)setAuthorizationWithSecretKey {
    NSAssert([InfobipSocialInvite isLibraryInitialized], @"Infobip Sosial Invite library is not initialized");
    NSAssert([InfobipSocialInvite secretKey], @"Infobip Sosial Invite secret key is not provided");
    
    [[objectManager HTTPClient] setDefaultHeader:@"Authorization"
                                           value:[NSString stringWithFormat:@"App %@", [InfobipSocialInvite secretKey]]];
}

#pragma mark - Social invite

+ (void)sendInviteToRecipients:(NSArray *)recipientsNumber
                 withMessageId:(NSString *)messageId
                    clientData:(NSArray *)clientData
                  successBlock:(IBSIResponseSuccess)successBlock
                  failureBlock:(IBSIResponseFailure)failureBlock
{
    IBSIPerson *person;
    // TODO remove this! Only for Demo App purposes
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"invitesEnabled"] boolValue]) {
        
        // New request object
        SocialInviteRequest *requestObject = [SocialInviteRequest new:objectManager];
        
        // If messageId is nil than use default message ID
        if (messageId) {
            requestObject.messageKey = messageId;
        } else {
            requestObject.messageKey = [InfobipSocialInvite defaultMessageId];
        }
        
        requestObject.sender = [InfobipSocialInvite senderId];
        
        // Add recipients
        Recipient *recipients = [Recipient new:objectManager];
        
        for (NSString *number in recipientsNumber) {
            person = [[InfobipSocialInvite addressBook] personWithMsisdn:number];
            Destinations *destination = [Destinations newWithAddress:number messageId:messageId clientData:[IBSIInvite populateClientData:clientData withPerson:person] objectManager:objectManager];
            [recipients addDestinationsObject:destination];
        }
        
        requestObject.recipients = recipients;
        __block NSArray *recipientsNumbersBlock = recipientsNumber;
        
        // set secretKey authorization and send invite request
        [self setAuthorizationWithSecretKey];
        [objectManager postObject:requestObject path:IBSI_PATH_SEND_INVITE parameters:nil
                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                              
                              // update recipients in Db with new bulkId
                              [IBSIInvite updateDatabaseWithBulkId:[[mappingResult firstObject] valueForKey:@"bulkId"] recipients:recipientsNumbersBlock];
                              successBlock([mappingResult firstObject]);
                              
                              // TODO remove this! Only for Demo App purposes
                              int invitesSum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"invitesCount"] intValue];
                              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(invitesSum + 1)] forKey:@"invitesCount"];
                              NSLog(@"Number of sent invites: %d", invitesSum + 1);
                          }
         
                          failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              NSLog(@"ERROR: %@", error);
                              failureBlock(error);
                          }];
    }
}

#pragma mark - Message editing

+ (void)getMessageByMessageId:(NSString *)messageId withSuccessBlock:(IBSIMessageResponseSuccess)successBlock failureBlock:(IBSIResponseFailure)failureBlock {
    
    NSString *url = [NSString stringWithFormat:IBSI_PATH_MESSAGE, [InfobipSocialInvite applicationKey], messageId];
    [self setAuthorizationWithSecretKey];
    [objectManager getObject:nil path:url parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"SUCCESS Message");
        successBlock([mappingResult firstObject]);
    }                failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR Message");
        failureBlock(error);
    }];
    
}

#pragma mark - Delivery Report

+ (void)getSocialInviteDeliveryInfoByBulkId:(NSString *)bulkId
                           withSuccessBlock:(IBSIDeliveryResponseSuccess)successBlock
                               failureBlock:(IBSIResponseFailure)failureBlock {
    
    if (![InfobipSocialInvite deliveryReportEnable]) {
        NSString *errDescription = NSLocalizedString(@"Invitation delivery reports are disabled.", @"");
        NSInteger errCode = 1100;
        NSError *err = [[NSError alloc] initWithDomain:@"IBErrorDomain"
                                                  code:errCode
                                              userInfo:@{NSLocalizedDescriptionKey : errDescription}];
        failureBlock(err);
    } else {
        NSString *url = [NSString stringWithFormat:IBSI_PATH_DELIVERY_REPORT, bulkId];
        [self setAuthorizationWithSecretKey];
        [objectManager getObject:nil path:url parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"SUCCESS DELIVERY");
            successBlock([mappingResult firstObject]);
        }                failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"ERROR DELIVERY");
            failureBlock(error);
        }];
    }
}


#pragma mark - Invitation management

+ (NSArray *)allInvites {
    NSError *error;
    
    NSFetchRequest *fetchDeliveryRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *deliveryInfoDescription = [NSEntityDescription entityForName:NSStringFromClass([DeliveryInfo class]) inManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext];
    [fetchDeliveryRequest setEntity:deliveryInfoDescription];
    
    NSArray *deliveryObjects = [objectManager.managedObjectStore.persistentStoreManagedObjectContext executeFetchRequest:fetchDeliveryRequest error:&error];
    NSMutableArray *allInvites = [[NSMutableArray alloc] init];
    for (NSManagedObject *deliver  in deliveryObjects) {
        IBSIInvitationInfo *invitationInfo = [[IBSIInvitationInfo alloc] initWithMsisdn:[deliver valueForKey:@"address"]
                                                                               personId:[[deliver valueForKey:@"personId"] intValue]
                                                                                 bulkId:[deliver valueForKey:@"clientCorrelator"]
                                                                         deliveryStatus:[deliver valueForKey:@"deliveryStatus"]];
        [allInvites addObject:invitationInfo];
    }
    
    return allInvites;
}

#pragma mark - Getting Delivery status from database

+ (NSString *)deliveryStatusForMsisdn:(NSString *)msisdn {
    if (![InfobipSocialInvite deliveryReportEnable]) {
        NSAssert([InfobipSocialInvite deliveryReportEnable], @"Delivery status fetching is disabled");
        return nil;
    } else {
        NSError *error;
        NSFetchRequest *fetchDeliveryRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *deliveryInfoDescription = [NSEntityDescription entityForName:NSStringFromClass([DeliveryInfo class]) inManagedObjectContext:objectManager.managedObjectStore.persistentStoreManagedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"address == %@", [IBSIUtils formatMsisdn:msisdn]];
        [fetchDeliveryRequest setPredicate:predicate];
        [fetchDeliveryRequest setEntity:deliveryInfoDescription];
        
        NSArray *deliveryObjects = [objectManager.managedObjectStore.persistentStoreManagedObjectContext executeFetchRequest:fetchDeliveryRequest error:&error];
        
        NSManagedObject *deliveryInfo = [deliveryObjects firstObject];
        return [deliveryInfo valueForKey:@"deliveryStatus"];
    }
}

#pragma mark - Database update

+ (void)updateDatabaseWithInvitationInfo:(IBSIInvitationInfo *)invitationInfo {
    NSError *error;
    
    NSManagedObjectContext *context = objectManager.managedObjectStore.persistentStoreManagedObjectContext;
    
    NSFetchRequest *deliveryRequestFind = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([DeliveryInfo class])];
    deliveryRequestFind.predicate = [NSPredicate predicateWithFormat:@"address == %@", [invitationInfo formattedMsisdn]];
    
    NSArray *matches = [context executeFetchRequest:deliveryRequestFind error:&error];
    if (error) {
        NSLog(@"Error while matching DeliveryInfo from CoreData: %@", [error localizedDescription]);
    }
    
    NSAssert(matches, @"Error: No matches found while matching DeliveryInfo from CoreData.");
    NSAssert([matches count] <= 1, @"Error: Duplicate matches found while matching DeliveryInfo from CoreData.");
    if (matches && [matches count] == 0) {
        // creating new item in CoreData
        NSManagedObject *invitationInfoMngObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DeliveryInfo class])
                                                                                 inManagedObjectContext:context];
        [invitationInfoMngObject setValue:[NSNumber numberWithInteger:invitationInfo.personId] forKey:@"personId"];
        [invitationInfoMngObject setValue:[invitationInfo formattedMsisdn] forKey:@"address"];
        [invitationInfoMngObject setValue:@"DeliveryUnknown" forKey:@"deliveryStatus"];
        if (![context save:&error]) {
            NSLog(@"Problem with invitationInfo pre insert: %@", [error localizedDescription]);
        }
    }
}

+ (void)updateDatabaseDeleteItemsWithoutBulkId {
    NSError *error;
    NSManagedObjectContext *context = objectManager.managedObjectStore.persistentStoreManagedObjectContext;
    
    NSFetchRequest *deliveryRequestFind = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([DeliveryInfo class])];
    deliveryRequestFind.predicate = [NSPredicate predicateWithFormat:@"clientCorrelator == nil"];
    
    NSArray *matches = [context executeFetchRequest:deliveryRequestFind error:&error];
    for (DeliveryInfo *deliveryInfo in matches) {
        [context deleteObject:deliveryInfo];
    }
    if (![context save:&error]) {
        NSLog(@"Problem with deliveryInfo deleting: %@", [error localizedDescription]);
    }
}

+ (void)updateDatabaseWithBulkId:(NSString *)bulkId recipients:(NSArray *)recipients {
    NSError *error;
    NSManagedObjectContext *context = objectManager.managedObjectStore.persistentStoreManagedObjectContext;
    
    NSFetchRequest *deliveryRequestFind = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([DeliveryInfo class])];
    deliveryRequestFind.predicate = [NSPredicate predicateWithFormat:@"address IN %@", recipients];
    
    NSArray *matches = [context executeFetchRequest:deliveryRequestFind error:&error];
    for (DeliveryInfo *match in matches) {
        if ([InfobipSocialInvite deliveryReportEnable]) {
            [match setValue:@"MessageWaiting" forKey:@"deliveryStatus"];
        } else {
            [match setValue:@"DeliveredToTerminal" forKey:@"deliveryStatus"];
        }
        [match setValue:bulkId forKey:@"clientCorrelator"];
    }
    if ([context save:&error]) {
        NSLog(@"Problem with updating bulkId in +updateDatabaseWithBulkId:recipients:");
        NSLog(@"Error: %@", error);
    }
}

+ (void)updateDatabaseWithUndefinedDeliveryStatusForBulkId:(NSString *)bulkId {
    NSError *error;
    NSManagedObjectContext *context = objectManager.managedObjectStore.persistentStoreManagedObjectContext;
    
    NSFetchRequest *deliveryRequestFind = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([DeliveryInfo class])];
    deliveryRequestFind.predicate = [NSPredicate predicateWithFormat:@"(clientCorrelator like %@) AND(deliveryStatus like %@)", bulkId, @"MessageWaiting"];
    
    NSArray *matches = [context executeFetchRequest:deliveryRequestFind error:&error];
    for (DeliveryInfo *match in matches) {
        [match setValue:@"DeliveryUndefined" forKey:@"deliveryStatus"];
    }
    if ([context save:&error]) {
        NSLog(@"Problem with updating delivery status in +updateDatabaseWithUndefindDeliveryStatusForBulkId:bulkId");
        NSLog(@"Error: %@", error);
    }
}

#pragma mark - UI

+ (void)startSocialInviteView:(UIViewController *)viewController block:(void (^)())block {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:IBSI_BUNDLE_NAME ofType:IBSI_BUNDLE_TYPE];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    UIStoryboard *siStoryboard = [UIStoryboard storyboardWithName:IBSI_STORYBOARD_NAME bundle:bundle];
    UIViewController *siVController = [siStoryboard instantiateInitialViewController];
    siVController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [viewController presentViewController:siVController animated:YES completion:^{
        NSLog(@"Start Social Invite storyboard");
        block();
    }];
}
#pragma mark - Client Data

+ (NSArray *)populateClientData:(NSArray *)clientsPlaceholderData withPerson:(IBSIPerson *)person {
    NSMutableArray *cliData = [[NSMutableArray alloc] init];
    NSArray *clientsPlaceholderOrderList = [InfobipSocialInvite clientListForPlaceholders];
    NSUInteger k = 0;
    if (clientsPlaceholderData == nil || [clientsPlaceholderData count] == 0) {
        if (clientsPlaceholderOrderList != nil || clientsPlaceholderOrderList.count != 0) {
            for (int i = 0; i < clientsPlaceholderOrderList.count; i++) {
                [cliData addObject:[IBSIInvite populateMessagePlaceholdersForData:[clientsPlaceholderOrderList objectAtIndex:i] withPerson:person]];
            }
        }
    } else {
        if (clientsPlaceholderOrderList != nil || clientsPlaceholderOrderList.count != 0) {
            for (NSUInteger i = 0; i < clientsPlaceholderOrderList.count; i++) {
                NSString *data = [IBSIInvite populateMessagePlaceholdersForData:[clientsPlaceholderOrderList objectAtIndex:i] withPerson:person];
                if ([data isEqualToString:[clientsPlaceholderOrderList objectAtIndex:i]]) {
                    if ([clientsPlaceholderData objectAtIndex:k] != nil) {
                        [cliData addObject:[clientsPlaceholderData objectAtIndex:k]];
                        k = k + 1;
                    }
                } else {
                    [cliData addObject:data];
                }
            }
        } else {
            for (int i = 0; i < clientsPlaceholderData.count; i++) {
                [cliData addObject:[clientsPlaceholderData objectAtIndex:i]];
            }
        }
    }
    return cliData;
}

+ (NSString *)populateMessagePlaceholdersForData:(NSString *)data withPerson:(IBSIPerson *)person {
    NSString *result = nil;
    if ([data isEqualToString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:SENDER_NAME]]) {
        NSAssert([InfobipSocialInvite senderId], @"Sender id is nil!");
        result = [InfobipSocialInvite senderId];
    } else if ([data isEqualToString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:RECEIVER_NAME]]) {
        NSAssert(person.name, @"Person name is nil!");
        result = person.name;
    } else if ([data isEqualToString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:END_USER_MSISDN]]) {
        NSAssert([InfobipSocialInvite endUserMsisdn], @"End user msisdn is nil!");
        result = [InfobipSocialInvite endUserMsisdn];
    } else if ([data isEqualToString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:END_USER_USERNAME]]) {
        NSAssert([InfobipSocialInvite endUserUsername], @"End user username is nil!");
        result = [InfobipSocialInvite endUserUsername];
    } else if ([data isEqualToString:[InfobipSocialInvite convertIBSIMessagePlaceholdersToString:CUSTOM_TEXT]]) {
        if ([InfobipSocialInvite customMessageText] == nil) {
            result = @"";
        } else {
            result = [InfobipSocialInvite customMessageText];
        }
    } else {
        result = data;
    }
    
    return result;
}

@end
