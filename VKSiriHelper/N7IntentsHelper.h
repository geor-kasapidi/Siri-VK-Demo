//
//  N7IntentsHelper.h
//  VKSiri
//
//  Created by Георгий Касапиди on 21.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import <Foundation/Foundation.h>

@class N7UserModel;

@interface N7IntentsHelper : NSObject

+ (void)registerUsersNamesFromUsersArray:(NSArray<N7UserModel *> *)usersArray;
+ (void)removeAllStrings;

@end
