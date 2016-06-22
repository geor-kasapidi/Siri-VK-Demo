//
//  N7IntentHandler.m
//  VKSiri
//
//  Created by Георгий Касапиди on 20.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import "N7IntentHandler.h"
#import "N7VKSendMessageHandler.h"

@implementation N7IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    if ([intent isKindOfClass:[INSendMessageIntent class]]) {
        return [N7VKSendMessageHandler new];
    }
    
    return nil;
}

@end
