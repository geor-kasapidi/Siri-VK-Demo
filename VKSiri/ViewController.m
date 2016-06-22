//
//  ViewController.m
//  VKSiri
//
//  Created by Георгий Касапиди on 20.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import "ViewController.h"
#import "N7VKManager.h"
#import "N7IntentsHelper.h"
#import "N7DataStore.h"

@interface ViewController () <N7VKManagerUIDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *loadUsersButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (strong, nonatomic) N7VKManager *vkManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vkManager = [N7VKManager new];
    
    self.vkManager.uiDelegate = self;
}

#pragma mark - Actions

- (IBAction)loginButtonTapped:(id)sender {
    [self.vkManager login];
}

- (IBAction)loadUsersButton:(id)sender {
    [self.loadingIndicator startAnimating];
    
    [self.vkManager loadFriendsWithCompletionHandler:^(NSArray<N7UserModel *> *users) {
        if (users.count > 0) {
            [N7DataStore setUsers:users];
            [N7IntentsHelper registerUsersNamesFromUsersArray:users];
        }
        
        [self.loadingIndicator stopAnimating];
    }];
}

- (IBAction)logoutButtonTapped:(id)sender {
    [self.vkManager logout];
}

#pragma mark - VK manager UI delegate

- (void)vkManager:(N7VKManager *)vkManager shouldPresentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
