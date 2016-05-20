//
//  BaseViewController.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "HomeMapViewController.h"

@interface BaseViewController ()
@property (nonatomic) HomeMapViewController *homeViewController;
@property (nonatomic) LoginViewController *loginViewController;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeViewController = [[HomeMapViewController alloc] init];
    self.homeViewController.baseViewControllerDelegate = self;
    
    self.loginViewController = [[LoginViewController alloc] init];
    self.loginViewController.baseViewControllerDelegate = self;
}

- (void)startup {
    if ([AppManager sharedInstance].accountManager.isAuthenticated ||
        [[NSUserDefaults standardUserDefaults] boolForKey:@"hasSkipped"]) {
        [self presentViewController:self.homeViewController
                           animated:NO
                         completion:nil];
    } else {
        [self presentViewController:self.homeViewController
                           animated:NO
                         completion:^{
                             [self.homeViewController presentViewController:self.loginViewController
                                                                   animated:YES
                                                                 completion:nil];
                         }];

    }
}

- (void)dismissViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addViewController:(UIViewController *)viewController {
    [self.homeViewController presentViewController:viewController animated:YES completion:nil];
}

@end
