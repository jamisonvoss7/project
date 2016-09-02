//
//  SignUpViewController.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "SignUpView.h"
#import "AccountService.h"

@interface SignUpView () <UITextFieldDelegate>
@property (nonatomic, assign) BOOL up;
@end

@implementation SignUpView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"SignUpView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
    [self addGestureRecognizer:tap];
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
    [self closeKeyboard];
    
    if (self.nameField.text.length == 0) {
        [self makeToast:@"Error: No name was provided" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.emailField.text.length == 0) {
        [self makeToast:@"Error: No email was specified" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.userNameField.text.length == 0) {
        [self makeToast:@"Error: No username was provided" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.passwordField.text.length == 0) {
        [self makeToast:@"Error: No password was specified" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    [self showActivityIndicatorWithCurtain:YES];
    
    Account *account = [[Account alloc] init];
    
    account.displayName = self.nameField.text;
    
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
                                  [self hideActivityIndicator];

                                  [self makeToast:@"Error: This username is taken"
                                         duration:2.0
                                         position:CSToastPositionCenter];
                              } else {
                                  [manager authenticateWithNewAccount:account
                                                   andUserCredentials:user
                                                       withCompletion:^(BOOL authenticated, NSError *error) {
                                                           [self hideActivityIndicator];

                                                           if (authenticated && !error) {
                                                               if (self.phoneNumberField.text.length > 0) {
                                                                   [self.flowDelegate showNextFlowStep:FlowStepVerifyPhone withObject:self.phoneNumberField.text];
                                                               } else {
                                                                   [self.flowDelegate showNextFlowStep:FlowStepAddContacts withObject:nil];
                                                               }
                                                           } else {
                                                               if (error.code == 17007) {
                                                                   [self makeToast:@"Error: This email address is already in use"
                                                                          duration:2.0
                                                                          position:CSToastPositionCenter];
                                                               } else if (error.code == 17026) {
                                                                   [self makeToast:@"Error: The password must be at least 6 characters"
                                                                          duration:2.0
                                                                          position:CSToastPositionCenter];
                                                               } else {
                                                                   [self makeToast:@"An error occurred"
                                                                          duration:2.0
                                                                          position:CSToastPositionCenter];
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
    [self closeKeyboard];
    [self.flowDelegate flowManagerGoBack];
}

- (void)animateViewUpForTextBox {
    if (self.up) {
        return;
    }
    
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y - 150;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.up = YES;
    }];
}

- (void)animateViewDownForTextBox {
    if (!self.up) {
        return;
    }
    
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y + 150;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.up = NO;
    }];
}

@end
