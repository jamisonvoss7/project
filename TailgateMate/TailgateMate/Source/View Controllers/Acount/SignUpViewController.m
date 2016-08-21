//
//  SignUpViewController.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "SignUpViewController.h"
#import "AddContactsViewController.h"

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

- (void)signUpButtonTapped:(UIButton *)sender {
    [self.view showActivityIndicatorWithCurtain:YES];
    
    Account *account = [[Account alloc] init];
    
    account.displayName = self.nameField.text;
    account.phoneNumber = self.phoneNumberField.text;
    
    UserCredentials *user = [[UserCredentials alloc] init];
    user.userName = self.emailField.text;
    user.password = self.passwordField.text;
    
    account.type = ACCOUNTTYPE_EMAIL;
    account.uid = [NSUUID UUID].UUIDString;
    account.emailAddress = self.emailField.text;
    account.userName = self.userNameField.text;
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    
    [manager authenticateWithNewAccount:account
                     andUserCredentials:user
                         withCompletion:^(BOOL authenticated, NSError *error) {
                            [self.view hideActivityIndicator];
                            
                             if (authenticated) {
                                 AddContactsViewController *vc = [[AddContactsViewController alloc] init];
                                 vc.authDelegate = self.authDelegate;
                                 [self.baseDelegate presentViewController:vc];
                             }
                         }];
}

- (void)goBack:(UIButton *)sender {
    [self.baseDelegate dismissViewController:self];
}

@end
