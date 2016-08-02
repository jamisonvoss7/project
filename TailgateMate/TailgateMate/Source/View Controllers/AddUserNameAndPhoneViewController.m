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
}

- (void)addDetails:(UIButton *)sender {
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
                                              if (success) {
                                                  AddContactsViewController *vc = [[AddContactsViewController alloc] init];
                                                  vc.authDelegate = self.authDelegate;
                                                  [self.baseDelegate addViewController:vc];
                                              }
                                          }];
                              } else {
                                  // report error
                              }
                          }];
  
}



@end
