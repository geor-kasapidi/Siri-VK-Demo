//
//  N7VKManager.m
//  VKSiri
//
//  Created by Георгий Касапиди on 20.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import <VK-ios-sdk/VKSdk.h>

#import "N7VKManager.h"
#import "N7DataStore.h"
#import "N7UserModel.h"

@interface N7VKManager () <VKSdkDelegate, VKSdkUIDelegate>

@property (copy, nonatomic) NSArray<NSString *> *permissions;

@property (strong, nonatomic) VKSdk *vkSdkInstance;

@end

@implementation N7VKManager

+ (instancetype)manager {
    static N7VKManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.permissions = @[VK_PER_FRIENDS, VK_PER_MESSAGES];
        
        self.vkSdkInstance = [VKSdk initializeWithAppId:@"5515150"];
        
        [self.vkSdkInstance registerDelegate:self];
        
        self.vkSdkInstance.uiDelegate = self;
    }
    
    return self;
}

+ (BOOL)processOpenURL:(NSURL *)passedUrl fromApplication:(NSString *)sourceApplication {
    return [VKSdk processOpenURL:passedUrl fromApplication:sourceApplication];
}

- (void)login {
    if ([VKSdk isLoggedIn]) {
        return;
    }
    
    [VKSdk wakeUpSession:self.permissions completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationInitialized) {
            [VKSdk authorize:self.permissions withOptions:VKAuthorizationOptionsUnlimitedToken | VKAuthorizationOptionsDisableSafariController];
        }
    }];
}

- (void)logout {
    [VKSdk forceLogout];
}

- (void)loadFriendsWithCompletionHandler:(void (^)(NSArray<N7UserModel *> *))completionHandler {
    VKRequest *friendRequest = [[VKApi friends] get:@{VK_API_FIELDS: @[@"first_name", @"last_name"]}];
    
    [friendRequest executeWithResultBlock:^(VKResponse *response) {
        NSMutableArray *users = [NSMutableArray array];
        
        for (NSDictionary *userDict in response.json[@"items"]) {
            NSString *userId = userDict[@"id"];
            NSString *firstName = userDict[@"first_name"];
            NSString *lastName = userDict[@"last_name"];
            
            N7UserModel *user = [N7UserModel new];
            
            user.userId = @([userId integerValue]);
            user.firstName = [firstName stringByApplyingTransform:NSStringTransformLatinToCyrillic reverse:NO];
            user.lastName = [lastName stringByApplyingTransform:NSStringTransformLatinToCyrillic reverse:NO];
            
            [users addObject:user];
        }
        
        if (completionHandler) {
            completionHandler(users);
        }
    } errorBlock:^(NSError *error) {
        if (completionHandler) {
            completionHandler(nil);
        }
    }];
}

- (void)sendMessage:(NSString *)message toUsersWithIDs:(NSArray<NSString *> *)usersIDs withCompletionHandler:(void (^)(NSError *))completionHandler {
    NSString *userId = [N7DataStore getUserId];
    NSString *token = [N7DataStore getTokenForAccount:userId];
    
    VKAccessToken *accessToken = [VKAccessToken tokenWithToken:token secret:nil userId:userId];
    
    VKRequest *request = [VKRequest requestWithMethod:@"messages.send" parameters:@{VK_API_USER_IDS: usersIDs, VK_API_MESSAGE: message}];
    
    [request setValue:accessToken forKey:@"specialToken"];
    
    [request executeWithResultBlock:^(VKResponse *response) {
        if (completionHandler) {
            completionHandler(nil);
        }
    } errorBlock:^(NSError *error) {
        if (completionHandler) {
            completionHandler(error);
        }
    }];
}

#pragma mark - Vk sdk delegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [N7DataStore setUserId:result.token.userId];
        [N7DataStore setToken:result.token.accessToken forAccount:result.token.userId];
    }
}

- (void)vkSdkUserAuthorizationFailed {
    
}

#pragma mark - Vk sdk UI delegate

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.uiDelegate vkManager:self shouldPresentViewController:controller];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *captchaVC = [VKCaptchaViewController captchaControllerWithError:captchaError];
    
    [self.uiDelegate vkManager:self shouldPresentViewController:captchaVC];
}

@end
