//
//  SignUpViewController.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "SignUpViewController.h"
#import "AccountManager.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.signUpButton addTarget:self
                          action:@selector(signUpButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.backbutton addTarget:self
                        action:@selector(goBack:)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.signUpButton.layer.cornerRadius = 15.0f;
    self.signUpButton.layer.borderWidth = 3.0f;
    self.signUpButton.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signUpButtonTapped:(UIButton *)sender {
    AccountManager *manager = [[AccountManager alloc] init];
    Account *account = [[Account alloc] init];
    
//    account.firstName = self.firstNameField.text;
//    account.lastName = self.lastNameField.text;
// 
    UserCredentials *user = [[UserCredentials alloc] init];
    user.userName = self.emailField.text;
    user.password = self.passwordField.text;
    
    account.credentials = user;
    
    [manager authenticateWithNewAccount:account
                         withCompletion:^(BOOL authenticated, NSError *error) {
                             [self.authDelegate didAuthenticate];
                         }];
}

- (void)goBack:(UIButton *)sender {
    [self.baseViewControllerDelegate dismissViewController:self];
}

@end
