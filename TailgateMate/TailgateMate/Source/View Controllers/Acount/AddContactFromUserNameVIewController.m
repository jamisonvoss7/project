//
//  AddContactFromUserNameVIewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/27/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddContactFromUserNameVIewController.h"
#import "ContactCardView.h"
#import "AccountService.h"
#import "NavbarView.h"

@interface AddContactFromUserNameVIewController () <ContactCardDelegate>
@property (nonatomic) NavbarView *navbarView;

@end

@implementation AddContactFromUserNameVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 

    [self.searchButton addTarget:self
                          action:@selector(search:)
                forControlEvents:UIControlEventTouchUpInside];
    
    self.searchButton.layer.cornerRadius = 15.0f;
    self.searchButton.layer.borderWidth = 3.0f;
    self.searchButton.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navbarView = [NavbarView instanceFromDefaultNib];
    self.navbarView.titleLabel.text = @"Contacts";
    self.navbarView.leftButton.text = @"Close";
    
    CGRect frame = self.navbarView.frame;
    frame.size.width = self.view.frame.size.width;
    self.navbarView.frame = frame;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeView:)];
    tap.numberOfTapsRequired = 1;
    [self.navbarView.leftButton addGestureRecognizer:tap];
    
    [self.view addSubview:self.navbarView];

}

- (void)search:(UIButton *)sender {
    if (self.searchField.text.length == 0) {
        [self showErrorToast:@"Please specify a usernaem"];
    }
    
    [self.searchField resignFirstResponder];
    
    AccountService *service = [[AccountService alloc] init];
    [service loadAccountFromUsername:self.searchField.text
                        withComplete:^(Account *account, NSError *error) {
                            if (account) {
                                if ([self accountAlreadyConnected:account]) {
                                    [self showToast:@"You already have this contact"];
                                } else {
                                    ContactCardView *card = [ContactCardView instanceWithDefaultNib];
                                    card.account = account;
                                    card.delegate = self;
                                
                                    card.frame = self.view.bounds;
                                    [self.view addSubview:card];
                                }
                            } else {
                                [self showErrorToast:@"No user found"];
                            }
                        }];
    
}

- (void)cardView:(ContactCardView *)cardView didAddWithContact:(Contact *)contact {
    [UIView animateWithDuration:.25 animations:^{
        cardView.hidden = YES;
    } completion:^(BOOL finished) {
        [cardView removeFromSuperview];
    }];
    
    if (contact) {
        Account *account = [AppManager sharedInstance].accountManager.profileAccount;
        NSMutableArray *contacts = [NSMutableArray arrayWithArray:account.contacts];
    
        [contacts addObject:contact];
        account.contacts = contacts;
    
        AccountService *service = [[AccountService alloc] init];
        [service saveAccount:account
                withComplete:^(BOOL success, NSError *error) {
                    if (success) {
                        [self showToast:@"Contact was added!"];
                    } else {
                        [self showToast:@"An error occurred"];
                    }
                }];
    }
}

- (void)closeView:(UITapGestureRecognizer *)sender {
    [self.baseDelegate dismissViewController:self];
}

- (BOOL)accountAlreadyConnected:(Account *)account {
    for (Contact *contact in [AppManager sharedInstance].accountManager.profileAccount.contacts) {
        if ([contact.userName isEqualToString:account.userName]) {
            return YES;
        }
    }
    return NO;
}

@end
