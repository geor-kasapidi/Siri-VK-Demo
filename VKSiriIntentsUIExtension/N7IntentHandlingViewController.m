//
//  N7IntentHandlingViewController.m
//  VKSiri
//
//  Created by Георгий Касапиди on 21.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import <Intents/Intents.h>

#import "N7IntentHandlingViewController.h"
#import "N7MessageViewController.h"

@interface N7IntentHandlingViewController ()

@property (weak, nonatomic) UIViewController<INUIHostedViewControlling, INUIHostedViewSiriProviding> *hostedViewController;

@end

@implementation N7IntentHandlingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.definesPresentationContext = YES;
}

#pragma mark - INUIHostedViewControlling

- (void)configureWithInteraction:(INInteraction *)interaction context:(INUIHostedViewContext)context completion:(void (^)(CGSize))completion {
    if ([interaction.intent isKindOfClass:[INSendMessageIntent class]]) {
        N7MessageViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([N7MessageViewController class])];
        
        [messageVC configureWithInteraction:interaction context:context completion:nil];
        
        [self presentViewController:messageVC animated:NO completion:nil];
        
        self.hostedViewController = messageVC;
        
        completion(self.extensionContext.hostedViewMaximumAllowedSize);
    }
    
    completion(CGSizeZero);
}

#pragma mark - INUIHostedViewSiriProviding

- (BOOL)displaysMessage {
    if ([self.hostedViewController respondsToSelector:@selector(displaysMessage)]) {
        return self.hostedViewController.displaysMessage;
    }
    
    return NO;
}

- (BOOL)displaysMap {
    if ([self.hostedViewController respondsToSelector:@selector(displaysMap)]) {
        return self.hostedViewController.displaysMap;
    }
    
    return NO;
}

@end
