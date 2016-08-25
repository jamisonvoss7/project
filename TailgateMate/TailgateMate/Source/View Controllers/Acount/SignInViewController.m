//
//  SignInViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 3/22/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "SignInViewController.h"
#import "AccountService.h"

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.signInButton addTarget:self
                          action:@selector(signInButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton addTarget:self
                        action:@selector(goBack:)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.signInButton.layer.cornerRadius = 15.0f;
    self.signInButton.layer.borderWidth = 3.0f;
    self.signInButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeKeyboard)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)signInButtonTapped:(UIButton *)sender {
    [self.view showActivityIndicatorWithCurtain:YES];
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    
    UserCredentials *user = [[UserCredentials alloc] init];
    user.userName = self.emailField.text;
    user.password = self.passwordField.text;
    
    [manager authenticateWithUserCredentials:user
                              withCompletion:^(BOOL authenticated, NSError *error) {
                                  [self.view hideActivityIndicator];
                                  
                                  if (authenticated && !error) {
                                      [self.baseDelegate dismissViewController:self];
                                      [self.authDelegate didAuthenticate];
                                  } else {
                                      if (error.code == 17009 ||
                                          error.code == 17011) {
                                          [self showErrorToast:@"This email/passord combination doesn't exist"];
                                      } else {
                                          [self showToast:@"An error occurred"];
                                      }
                                  }
                              }];
}

- (void)goBack:(UIButton *)sender {
    [self.baseDelegate dismissViewController:self];
}

- (void)closeKeyboard {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
@end
