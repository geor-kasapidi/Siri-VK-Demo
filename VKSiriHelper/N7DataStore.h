//
//  N7DataStore.h
//  VKSiri
//
//  Created by Георгий Касапиди on 21.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import <Foundation/Foundation.h>

@class N7UserModel;

@interface N7DataStore : NSObject

+ (NSString *)getTokenForAccount:(NSString *)account;
+ (void)setToken:(NSString *)token forAccount:(NSString *)account;

+ (NSString *)getUserId;
+ (void)setUserId:(NSString *)userId;

+ (NSArray<N7UserModel *> *)getUsers;
+ (void)setUsers:(NSArray<N7UserModel *> *)users;

@end
