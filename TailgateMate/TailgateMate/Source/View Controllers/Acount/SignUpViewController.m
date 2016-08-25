//
//  SignUpViewController.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "SignUpViewController.h"
#import "AddContactsViewController.h"
#import "AccountService.h"
#import "PhoneVerificationViewController.h"

@interface SignUpViewController () <UITextFieldDelegate>
@property (nonatomic, assign) BOOL up;
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
    
    self.nameField.delegate = self;
    self.emailField.delegate = self;
    self.userNameField.delegate = self;
    self.phoneNumberField.delegate = self;
    self.passwordField.delegate = self;
    
    self.up = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeKeyboard)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.phoneNumberField ||
        textField == self.passwordField) {
        [self animateViewUpForTextBox];
    } else {
        [self animateViewDownForTextBox];
    }
    return YES;
}

- (void)signUpButtonTapped:(UIButton *)sender {
    [self animateViewDownForTextBox];
    
    if (self.nameField.text.length == 0) {
        [self showErrorToast:@"No name was provided"];
        return;
    }
    
    if (self.emailField.text.length == 0) {
        [self showErrorToast:@"No email was specified"];
        return;
    }
    
    if (self.userNameField.text.length == 0) {
        [self showErrorToast:@"No username was provided"];
        return;
    }
    
    if (self.passwordField.text.length == 0) {
        [self showErrorToast:@"No password was specified"];
        return;
    }
    
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
    AccountService *service = [[AccountService alloc] init];
    [service checkUserNameAvailability:account.userName
                          withComplete:^(BOOL available, NSError *error) {
                              if (!available) {
                                  [self.view hideActivityIndicator];

                                  [self showErrorToast:@"This username is taken"];
                                   
                              } else {
                                  [manager authenticateWithNewAccount:account
                                                   andUserCredentials:user
                                                       withCompletion:^(BOOL authenticated, NSError *error) {
                                                           [self.view hideActivityIndicator];

                                                           if (authenticated && !error) {

                                                               if (account.phoneNumber.length > 0) {
                                                                   PhoneVerificationViewController *phoneVC = [[PhoneVerificationViewController alloc] initWithPhonenumber:account.phoneNumber];
                                                               
                                                               }
                            
                                                               AddContactsViewController *vc = [[AddContactsViewController alloc] init];
                                                               [vc onDismissHandler:^{
                                                                   [self.baseDelegate dismissViewController:self WithComplete:^{
                                                                       [self.authDelegate didAuthenticate];
                                                                   }];
                                                               }];
                                                               [self.baseDelegate presentViewController:vc];
                                                           } else {
                                                               if (error.code == 17007) {
                                                                   [self showErrorToast:@"This email address is already in use"];
                                                               } else if (error.code == 17026) {
                                                                   [self showErrorToast:@"The password must be at least 6 characters"];
                                                               } else {
                                                                   [self showToast:@"An error occurred"];
                                                               }
                                                           }
                                                       }];
                              }
                          }];
    
   
}

- (void)closeKeyboard {
    [self.nameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.userNameField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    [self animateViewDownForTextBox];
}

- (void)goBack:(UIButton *)sender {
    [self.baseDelegate dismissViewController:self];
}

- (void)animateViewUpForTextBox {
    if (self.up) {
        return;
    }
    
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = frame.origin.y - 100;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        self.up = YES;
    }];
}

- (void)animateViewDownForTextBox {
    if (!self.up) {
        return;
    }
    
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = frame.origin.y + 100;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        self.up = NO;
    }];
}

@end
