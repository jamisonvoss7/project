//
//  ProfileEditView.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ProfileEditView.h"

@interface ProfileEditView ()
@property (nonatomic, assign) BOOL up;
@end

@implementation ProfileEditView

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"ProfileEditView"
                                bundle:[NSBundle mainBundle]];
    
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeKeyboards)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    self.emailField.hidden = YES;
    
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
    if (account.type == ACCOUNTTYPE_EMAIL) {
        self.emailField.hidden = NO;
    }
    
    self.emailField.delegate = self;
    self.nameField.delegate = self;
    self.phoneNumberField.delegate = self;
    self.userNameField.delegate = self;
    
    [self reload];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.emailField) {
        [self animateViewUpForTextBox];
    } else {
        [self animateViewDownForTextBox];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self closeKeyboards];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
    
    if (textField == self.nameField) {
        if (![account.displayName isEqualToString:self.nameField.text]) {
            [self.profileDelegate updateName:textField.text];
        }
    } else if (textField == self.emailField) {
        if (![account.emailAddress isEqualToString:self.emailField.text]) {
            [self.profileDelegate updateEmail:textField.text];
        }
    } else if (textField == self.userNameField) {
        if (![account.userName isEqualToString:self.userNameField.text]) {
            [self.profileDelegate updateUserName:textField.text];
        }
    } else if (textField == self.phoneNumberField) {
        if (![account.phoneNumber isEqualToString:self.phoneNumberField.text]) {
            [self.profileDelegate updatePhoneNumber:textField.text];
        }
    }
}

- (void)reload {
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
  
    self.nameField.text = account.displayName;
    self.emailField.text = account.emailAddress;
    self.phoneNumberField.text = account.phoneNumber;
    self.userNameField.text = account.userName;
    
}

- (void)closeKeyboards {
    [self.nameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
    [self.userNameField resignFirstResponder];
    
    [self animateViewDownForTextBox];
}


- (void)animateViewUpForTextBox {
    if (self.up) {
        return;
    }
    
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y - 75;
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
        frame.origin.y = frame.origin.y + 75;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.up = NO;
    }];
}

@end
