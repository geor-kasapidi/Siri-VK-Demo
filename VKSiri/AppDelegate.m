//
//  AppDelegate.m
//  VKSiri
//
//  Created by Георгий Касапиди on 20.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import <Intents/Intents.h>

#import "AppDelegate.h"
#import "N7VKManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
        
    }];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [N7VKManager processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    
    return YES;
}

@end
