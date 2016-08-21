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
                                  
                                  if (authenticated) {
                                      [self.baseDelegate dismissViewController:self];
                                      [self.authDelegate didAuthenticate];
                                  }
                              }];
}

- (void)goBack:(UIButton *)sender {
    [self.baseDelegate dismissViewController:self];
}

@end
