//
//  N7IntentsHelper.m
//  VKSiri
//
//  Created by Георгий Касапиди on 21.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

@import Intents;

#import "N7IntentsHelper.h"
#import "N7UserModel.h"

@implementation N7IntentsHelper

+ (void)registerUsersNamesFromUsersArray:(NSArray<N7UserModel *> *)usersArray {
    NSMutableOrderedSet<NSString *> *usersNames = [NSMutableOrderedSet orderedSet];
    
    [usersArray enumerateObjectsUsingBlock:^(N7UserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [usersNames addObject:[NSString stringWithFormat:@"%@ %@", obj.firstName, obj.lastName]];
    }];
    
    [[INVocabulary sharedVocabulary] setVocabularyStrings:[usersNames copy] ofType:INVocabularyStringTypeContactName];
}

+ (void)removeAllStrings {
    [[INVocabulary sharedVocabulary] removeAllVocabularyStrings];
}

@end
