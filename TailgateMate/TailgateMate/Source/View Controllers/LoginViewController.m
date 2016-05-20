//
//  LoginViewController.m
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"

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
    
    self.facebbokButton.layer.cornerRadius = 15.0f;
    self.twitterButton.layer.cornerRadius = 15.0f;
    self.emailButton.layer.cornerRadius = 15.0f;
    self.basicAccountButton.layer.cornerRadius = 15.0f;
    
    self.facebbokButton.layer.borderWidth = 3.0f;
    self.twitterButton.layer.borderWidth = 3.0f;
    self.emailButton.layer.borderWidth = 3.0f;
    self.basicAccountButton.layer.borderWidth = 3.0f;
    
    self.facebbokButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.twitterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.emailButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.basicAccountButton.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)facebookButtonAction:(UIButton *)sender {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    [manager signInWithFacebookFromViewController:self
                                   withCompletion:^(BOOL success, NSError *error) {
                                       [self.baseViewControllerDelegate dismissViewController:self];
                                   }];
}

- (void)signUpBUttonTapped:(UIButton *)sender {
    SignUpViewController *vc = [[SignUpViewController alloc] init];
    vc.authDelegate = self;
    vc.baseViewControllerDelegate = self.baseViewControllerDelegate;

    [self presentViewController:vc
                       animated:YES
                     completion:^{
        
                     }];
}

- (void)signInButtonTapped:(UIButton *)sender {
    SignInViewController *vc = [[SignInViewController alloc] init];
    vc.authDelegate = self;
    vc.baseViewControllerDelegate = self.baseViewControllerDelegate;

    [self presentViewController:vc
                     animated:YES
                   completion:^{
    
                   }];
}

- (void)skipButtonTapped:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"hasSkipped"];
    
    [self.baseViewControllerDelegate dismissViewController:self];
}

- (void)didAuthenticate {
    [self.baseViewControllerDelegate dismissViewController:self];
}

- (void)failedToAuthenticate {
    
}

@end
