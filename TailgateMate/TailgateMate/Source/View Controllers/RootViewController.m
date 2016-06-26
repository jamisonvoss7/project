//
//  BaseViewController.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "LandingViewController.h"

@interface RootViewController ()
@property (nonatomic) LandingViewController *landingViewController;
@property (nonatomic) LoginViewController *loginViewController;
@property (nonatomic) UIViewController *currentViewController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.landingViewController = [[LandingViewController alloc] init];
    
    self.loginViewController = [[LoginViewController alloc] init];
}

- (void)startup {
    if ([AppManager sharedInstance].accountManager.isAuthenticated ||
        [[NSUserDefaults standardUserDefaults] boolForKey:@"hasSkipped"]) {
        self.currentViewController = self.landingViewController;
        [self presentViewController:self.landingViewController
                           animated:NO
                         completion:nil];
    } else {
        [self presentViewController:self.landingViewController
                           animated:NO
                         completion:^{
                             self.currentViewController = self.loginViewController;
                             
                             [self.landingViewController presentViewController:self.loginViewController
                                                                   animated:YES
                                                                 completion:nil];
                         }];

    }
}

- (void)dismissViewController:(UIViewController *)viewController {
    self.currentViewController = viewController.presentingViewController;
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addViewController:(UIViewController *)viewController {
    if (self.currentViewController) {
        [self.currentViewController presentViewController:viewController
                                                 animated:YES
                                               completion:^{
                                                   self.currentViewController = viewController;
                                               }];
    } else {
        [self.landingViewController presentViewController:viewController
                                                 animated:YES
                                               completion:^{
                                                   self.currentViewController = viewController;
                                               }];
    }
}

@end
