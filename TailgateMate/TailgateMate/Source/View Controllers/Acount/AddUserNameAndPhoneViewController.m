//
//  AddUserNameAndPhoneViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddUserNameAndPhoneViewController.h"
#import "AddContactsViewController.h"
#import "AccountService.h"

@interface AddUserNameAndPhoneViewController ()

@end

@implementation AddUserNameAndPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.addButton addTarget:self
                          action:@selector(addDetails:)
                forControlEvents:UIControlEventTouchUpInside];
    
    self.addButton.layer.cornerRadius = 15.0f;
    self.addButton.layer.borderWidth = 3.0f;
    self.addButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeKeyboard)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)addDetails:(UIButton *)sender {
    if (self.userNameField.text.length == 0) {
        [self showErrorToast:@"Please enter a username"];
        return;
    }
    
    Account *currentAccount = [AppManager sharedInstance].accountManager.profileAccount;
    currentAccount.userName = self.userNameField.text;
    currentAccount.phoneNumber = self.phoneNumberField.text;
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    AccountService *service = [[AccountService alloc] init];
    [service checkUserNameAvailability:self.userNameField.text
                          withComplete:^(BOOL available, NSError *error) {
                              if (available) {
                                  [manager saveAccount:currentAccount
                                          withComplete:^(BOOL success, NSError *error) {
                                              if (success && [AppManager sharedInstance].accountManager.profileAccount.contacts.count == 0) {
                                                  AddContactsViewController *vc = [[AddContactsViewController alloc] init];
                                                  [vc onDismissHandler:^{
                                                      [self.baseDelegate dismissViewController:self WithComplete:^{
                                                          [self.authDelegate didAuthenticate];
                                                      }];
                                                  }];
                                                  [self.baseDelegate presentViewController:vc];
                                              }
                                          }];
                              } else {
                                  [self.view hideActivityIndicator];
                                  [self showErrorToast:@"This username is taken"];
                              }
                          }];
  
}

- (void)closeKeyboard {
    [self.userNameField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
}

@end
