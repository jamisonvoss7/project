//
//  SignInViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 3/22/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "SignInView.h"
#import "AccountService.h"

@implementation SignInView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"SignInView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
    [self addGestureRecognizer:tap];
}

- (void)signInButtonTapped:(UIButton *)sender {
    [self closeKeyboard];
    
    [self showActivityIndicatorWithCurtain:YES];
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    
    UserCredentials *user = [[UserCredentials alloc] init];
    user.userName = self.emailField.text;
    user.password = self.passwordField.text;
    
    [manager authenticateWithUserCredentials:user
                              withCompletion:^(BOOL authenticated, NSError *error) {
                                  [self hideActivityIndicator];
                                  
                                  if (authenticated && !error) {
                                      [self.flowDelegate showNextFlowStep:FlowStepDone withObject:nil];
                                  } else {
                                      if (error.code == 17009 ||
                                          error.code == 17011) {
                                          [self showErrorToast:@"This email/passord combination doesn't exist"];
                                      } else {
                                          [self showAToast:@"An error occurred"];
                                      }
                                  }
                              }];
}

- (void)goBack:(UIButton *)sender {
    [self closeKeyboard];
    [self.flowDelegate flowManagerGoBack];
}

- (void)closeKeyboard {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
@end
