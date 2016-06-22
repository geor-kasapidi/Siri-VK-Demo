//
//  N7VKManager.h
//  VKSiri
//
//  Created by Георгий Касапиди on 20.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

@class N7VKManager;
@class N7UserModel;

@protocol N7VKManagerUIDelegate <NSObject>

@required

- (void)vkManager:(N7VKManager *)vkManager shouldPresentViewController:(UIViewController *)viewController;

@end

@interface N7VKManager : NSObject

@property (weak, nonatomic) id<N7VKManagerUIDelegate> uiDelegate;

+ (instancetype)manager;

+ (BOOL)processOpenURL:(NSURL *)passedUrl fromApplication:(NSString *)sourceApplication;

- (void)login;
- (void)logout;

- (void)loadFriendsWithCompletionHandler:(void (^)(NSArray<N7UserModel *> *users))completionHandler;

- (void)sendMessage:(NSString *)message toUsersWithIDs:(NSArray<NSString *> *)usersIDs withCompletionHandler:(void (^)(NSError *error))completionHandler;

@end
