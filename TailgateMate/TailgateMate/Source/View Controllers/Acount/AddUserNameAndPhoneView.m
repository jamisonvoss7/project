//
//  AddUserNameAndPhoneViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddUserNameAndPhoneView.h"
#import "AccountService.h"

@interface AddUserNameAndPhoneView ()

@end

@implementation AddUserNameAndPhoneView

+ (instancetype)instanceWithDefualtNib {
    UINib *nib = [UINib nibWithNibName:@"AddUserNameAndPhoneView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.addButton addTarget:self
                          action:@selector(addDetails:)
                forControlEvents:UIControlEventTouchUpInside];
    
    self.addButton.layer.cornerRadius = 15.0f;
    self.addButton.layer.borderWidth = 3.0f;
    self.addButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeKeyboard)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)addDetails:(UIButton *)sender {
    [self closeKeyboard];
    
    if (self.userNameField.text.length == 0) {
        [self makeToast:@"Error: Please enter a username"
               duration:2.0
               position:CSToastPositionCenter];
        return;
    }
    
    Account *currentAccount = [AppManager sharedInstance].accountManager.profileAccount;
    currentAccount.userName = self.userNameField.text;
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    AccountService *service = [[AccountService alloc] init];
 
    [self showActivityIndicatorWithCurtain:YES];
    
    [service checkUserNameAvailability:self.userNameField.text
                          withComplete:^(BOOL available, NSError *error) {
                              [self hideActivityIndicator];
                              if (available) {
                                  [manager saveAccount:currentAccount
                                          withComplete:^(BOOL success, NSError *error) {
                                              if (success) {
                                                  if (self.phoneNumberField.text.length > 0) {
                                                      [self.flowDelegate showNextFlowStep:FlowStepVerifyPhone withObject:self.phoneNumberField.text];
                                                  } else if (success &&
                                                             [AppManager sharedInstance].accountManager.profileAccount.contacts.count == 0) {
                                                      [self.flowDelegate showNextFlowStep:FlowStepAddContacts withObject:nil];
                                                  } else {
                                                      [self.flowDelegate showNextFlowStep:FlowStepDone withObject:nil];
                                                  }
                                              } else {
                                                  [self makeToast:@"An error occurred." duration:2.0 position:CSToastPositionCenter];
                                              }
                                          }];
                              } else {
                                  [self makeToast:@"Error: This username is taken" duration:2.0 position:CSToastPositionCenter];
                              }
                          }];
  
}

- (void)closeKeyboard {
    [self.userNameField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
}

@end
