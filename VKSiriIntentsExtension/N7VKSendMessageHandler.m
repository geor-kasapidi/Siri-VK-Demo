//
//  N7VKSendMessageHandler.m
//  VKSiri
//
//  Created by Георгий Касапиди on 20.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import "N7VKSendMessageHandler.h"
#import "N7VKManager.h"
#import "N7DataStore.h"
#import "N7UserModel.h"

@implementation N7VKSendMessageHandler

- (void)resolveRecipientsForSendMessage:(INSendMessageIntent *)intent withCompletion:(void (^)(NSArray<INPersonResolutionResult *> * _Nonnull))completion {
    if (intent.recipients.count == 0) {
        completion(@[[INPersonResolutionResult needsValue]]);
        
        return;
    }
    
    NSArray<N7UserModel *> *users = [N7DataStore getUsers];
    
    if (users.count == 0) {
        completion(@[[INPersonResolutionResult needsValue]]);
        
        return;
    }
    
    NSMutableArray<INPersonResolutionResult *> *resolutionResults = [NSMutableArray array];
    
    for (INPerson *recipient in intent.recipients) {
        NSIndexSet *indexSet = [users indexesOfObjectsPassingTest:^BOOL(N7UserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [[NSString stringWithFormat:@"%@ %@", obj.firstName, obj.lastName] rangeOfString:recipient.displayName options:NSCaseInsensitiveSearch].location != NSNotFound;
        }];
        
        if (indexSet.count == 0) {
            [resolutionResults addObject:[INPersonResolutionResult unsupportedWithReason:INIntentResolutionResultUnsupportedReasonNone]];
        } else if (indexSet.count == 1) {
            N7UserModel *user = users[indexSet.firstIndex];
            
            INPerson *resolvedPerson = [[INPerson alloc] initWithHandle:[user.userId stringValue] displayName:[NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName] contactIdentifier:nil];
            
            [resolutionResults addObject:[INPersonResolutionResult successWithResolvedPerson:resolvedPerson]];
        } else {
            NSMutableArray<INPerson *> *peopleToDisambiguate = [NSMutableArray array];
            
            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                N7UserModel *user = users[idx];
                
                INPerson *person = [[INPerson alloc] initWithHandle:[user.userId stringValue] displayName:[NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName] contactIdentifier:nil];
                [peopleToDisambiguate addObject:person];
            }];
            
            [resolutionResults addObject:[INPersonResolutionResult disambiguationWithPeopleToDisambiguate:peopleToDisambiguate]];
        }
    }
    
    completion(resolutionResults);
}

- (void)resolveContentForSendMessage:(INSendMessageIntent *)intent withCompletion:(void (^)(INStringResolutionResult * _Nonnull))completion {
    if (intent.content.length > 0) {
        completion([INStringResolutionResult successWithResolvedString:intent.content]);
    } else {
        completion([INStringResolutionResult needsValue]);
    }
}

- (void)confirmSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse * _Nonnull))completion {
    completion([[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeSuccess userActivity:nil]);
}

- (void)handleSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse * _Nonnull))completion {
    if (intent.recipients.count > 0 && intent.content.length > 0) {
        NSString *message = intent.content;
        
        NSMutableArray<NSString *> *usersIDs = [NSMutableArray array];
        
        [intent.recipients enumerateObjectsUsingBlock:^(INPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [usersIDs addObject:obj.handle];
        }];
        
        [[N7VKManager manager] sendMessage:message toUsersWithIDs:usersIDs withCompletionHandler:^(NSError *error) {
            if (!error) {
                completion([[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeSuccess userActivity:nil]);
            } else {
                completion([[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeFailure userActivity:nil]);
            }
        }];
    } else {
        completion([[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeFailure userActivity:nil]);
    }
}

@end
