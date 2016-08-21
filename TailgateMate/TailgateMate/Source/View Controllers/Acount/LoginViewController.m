//
//  LoginViewController.m
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "AddUserNameAndPhoneViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init {
    self = [super initWithNibName:@"LoginViewController"
                           bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.facebbokButton addTarget:self
                            action:@selector(facebookButtonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.emailButton addTarget:self
                         action:@selector(signInButtonTapped:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.basicAccountButton addTarget:self
                                action:@selector(signUpBUttonTapped:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [self.skipButton addTarget:self
                        action:@selector(skipButtonTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    
    
    self.facebbokButton.layer.cornerRadius = 15.0f;
    self.twitterButton.layer.cornerRadius = 15.0f;
    self.emailButton.layer.cornerRadius = 15.0f;
    self.basicAccountButton.layer.cornerRadius = 15.0f;
    self.skipButton.layer.cornerRadius = 15.0f;
    
    self.facebbokButton.layer.borderWidth = 3.0f;
    self.twitterButton.layer.borderWidth = 3.0f;
    self.emailButton.layer.borderWidth = 3.0f;
    self.basicAccountButton.layer.borderWidth = 3.0f;
    self.skipButton.layer.borderWidth = 3.0f;
    
    self.facebbokButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.twitterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.emailButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.basicAccountButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.skipButton.layer.borderColor = [[UIColor whiteColor] CGColor];

}

- (void)facebookButtonAction:(UIButton *)sender {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    [manager signInWithFacebookFromViewController:self
                                   withCompletion:^(BOOL success, NSError *error) {
                                       if (success) {
                                           if ([AppManager sharedInstance].accountManager.profileAccount.userName.length == 0) {
                                               AddUserNameAndPhoneViewController *vc = [[AddUserNameAndPhoneViewController alloc] init];
                                               vc.authDelegate = self;
                                               [self.baseDelegate presentViewController:vc];
                                           } else {
                                               [self.baseDelegate dismissViewController:self];
                                           }
                                       }
                                   }];
}

- (void)signUpBUttonTapped:(UIButton *)sender {
    SignUpViewController *vc = [[SignUpViewController alloc] init];
    vc.authDelegate = self;
    [self.baseDelegate presentViewController:vc];
}

- (void)signInButtonTapped:(UIButton *)sender {
    SignInViewController *vc = [[SignInViewController alloc] init];
    vc.authDelegate = self;
    [self.baseDelegate presentViewController:vc];
}

- (void)skipButtonTapped:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"hasSkipped"];
    
    [self.baseDelegate dismissViewController:self];
}

- (void)didAuthenticate {
    [self.baseDelegate dismissViewController:self];
}

- (void)failedToAuthenticate {
    
}

@end
