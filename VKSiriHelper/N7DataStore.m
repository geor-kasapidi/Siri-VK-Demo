//
//  N7DataStore.m
//  VKSiri
//
//  Created by Георгий Касапиди on 21.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>

#import "N7DataStore.h"
#import "N7UserModel.h"

static NSString * const N7VKSiriKeychainAccessGroup = @"<value>";
static NSString * const N7VKSiriApplicationGroup = @"<value>";

@implementation N7DataStore

#pragma mark - Token

+ (SSKeychainQuery *)tokenQueryForAccount:(NSString *)account {
    SSKeychainQuery *query = [SSKeychainQuery new];
    
    query.accessGroup = N7VKSiriKeychainAccessGroup;
    query.service = @"vk";
    query.account = account;
    
    return query;
}

+ (NSString *)getTokenForAccount:(NSString *)account {
    SSKeychainQuery *query = [self tokenQueryForAccount:account];
    
    if ([query fetch:nil]) {
        return query.password;
    }
    
    return nil;
}

+ (void)setToken:(NSString *)token forAccount:(NSString *)account {
    SSKeychainQuery *query = [self tokenQueryForAccount:account];
    
    [query setPassword:token];
    
    [query save:nil];
}

#pragma mark - User Id

+ (NSUserDefaults *)sharedDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:N7VKSiriApplicationGroup];
}

+ (NSString *)getUserId {
    return [[self sharedDefaults] stringForKey:@"user_id"];
}

+ (void)setUserId:(NSString *)userId {
    [[self sharedDefaults] setObject:userId forKey:@"user_id"];
}

#pragma mark - Users

+ (NSString *)usersFilePath {
    NSString *filePath = [[[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:N7VKSiriApplicationGroup] URLByAppendingPathComponent:@"users"] URLByAppendingPathExtension:@"dat"] relativePath];
    
    return filePath;
}

+ (NSArray<N7UserModel *> *)getUsers {
    NSArray<N7UserModel *> *users = [NSKeyedUnarchiver unarchiveObjectWithFile:[self usersFilePath]];
    
    return users;
}

+ (void)setUsers:(NSArray<N7UserModel *> *)users {
    [NSKeyedArchiver archiveRootObject:users toFile:[self usersFilePath]];
}

@end
