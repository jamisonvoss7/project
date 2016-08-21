//
//  BaseViewController.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "LandingViewController.h"

@interface PresentationNavigationController : UINavigationController

@end

@implementation PresentationNavigationController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end

@interface RootViewController ()
@property (nonatomic) LandingViewController *landingViewController;
@property (nonatomic) LoginViewController *loginViewController;
@property (nonatomic) UIViewController *currentViewController;
@property (nonatomic) UINavigationController *currentNavigationViewController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_drop"]];
    
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
    if ([self.currentViewController isKindOfClass:PresentationNavigationController.class]) {
        PresentationNavigationController *nav = (PresentationNavigationController *)self.currentViewController;
        if (nav.viewControllers.count > 1) {
            [nav popViewControllerAnimated:YES];
        } else {
            self.currentViewController = viewController.presentingViewController;
            [viewController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        self.currentViewController = viewController.presentingViewController;
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)presentViewController:(UIViewController *)viewController {
    if (self.currentViewController) {
        if ([self.currentViewController isKindOfClass:PresentationNavigationController.class]) {
            PresentationNavigationController *nav = (PresentationNavigationController *)self.currentViewController;
            [nav pushViewController:viewController animated:YES];
        } else {
            [self.currentViewController presentViewController:viewController
                                                     animated:YES
                                                   completion:^{
                                                       self.currentViewController = viewController;
                                                   }];
        }
    } else {
        [self.landingViewController presentViewController:viewController
                                                 animated:YES
                                               completion:^{
                                                   self.currentViewController = viewController;
                                               }];
    }
}

- (void)presentViewControllerInNavigation:(UIViewController *)viewController {
    PresentationNavigationController *nav = [[PresentationNavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav];
}

@end
