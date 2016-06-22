//
//  N7MessageViewController.m
//  VKSiri
//
//  Created by Георгий Касапиди on 21.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import <Intents/Intents.h>

#import "N7MessageViewController.h"

@interface N7MessageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *vkLogo;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *status;

@end

@implementation N7MessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userLabel.text = self.userName;
    self.messageLabel.text = self.message;
    self.statusLabel.text = self.status;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.vkLogo duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:^(BOOL finished) {
            [UIView transitionWithView:self.vkLogo duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:^(BOOL finished) {
                
            }];
        }];
    });
}

- (void)configureWithInteraction:(INInteraction *)interaction context:(INUIHostedViewContext)context completion:(void (^)(CGSize))completion {
    INSendMessageIntent *messageIntent = (INSendMessageIntent *)interaction.intent;
    
    self.userName = messageIntent.recipients.firstObject.displayName;
    self.message = messageIntent.content;
    
    switch (interaction.intentHandlingStatus) {
        case INIntentHandlingStatusReady: {
            self.status = @"ready";
            
            break;
        }
        case INIntentHandlingStatusInProgress: {
            self.status = @"in progress";
            
            break;
        }
        case INIntentHandlingStatusDone: {
            self.status = @"done";
            
            break;
        }
        case INIntentHandlingStatusUnspecified:
        default: {
            self.status = @"unspecified";
            
            break;
        }
    }
}

- (BOOL)displaysMessage {
    return YES;
}

@end
