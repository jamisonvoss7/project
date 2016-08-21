//
//  ProfileViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileView.h"
#import "ProfileEditView.h"
#import "NavbarView.h"
#import "AddContactsViewController.h"
#import "ContactsViewControler.h"

@interface ProfileViewController ()
@property (nonatomic) ProfileView *profileView;
@property (nonatomic) ProfileEditView *editView;
@property (nonatomic) UIBarButtonItem *barButton;
@property (nonatomic) NavbarView *navbarView;
@property (nonatomic, assign) BOOL isEditiing;
@end

@implementation ProfileViewController

- (id)init {
    self = [super initWithNibName:@"ProfileViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navbarView = [NavbarView instanceFromDefaultNib];
    self.navbarView.titleLabel.text = @"Profile";
    self.navbarView.leftButton.text = @"Close";
    self.navbarView.rightButton.text = @"Edit";
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(leftButtonAction:)];
    closeTap.numberOfTapsRequired = 1;
    [self.navbarView.leftButton addGestureRecognizer:closeTap];
    
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(rightButtonAction:)];
    editTap.numberOfTapsRequired = 1;
    [self.navbarView.rightButton addGestureRecognizer:editTap];
    
    [self.view addSubview:self.navbarView];
    
    CGSize size = self.containerView.contentSize;
    size.width = self.view.frame.size.width;
    self.containerView.contentSize = size;
    
    self.containerView.scrollEnabled = NO;
    
    self.isEditiing = NO;
    
    self.profileView = [ProfileView instanceFromDefaultNib];
    self.editView = [ProfileEditView instanceFromDefaultNib];
    
    CGRect frame = self.editView.frame;
    frame.origin.x = self.view.frame.size.width;
    self.editView.frame = frame;
    
    [self.containerView addSubview:self.profileView];
    [self.containerView addSubview:self.editView];
    
    self.signoutButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.signoutButton addTarget:self
                           action:@selector(signOutHandler:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.profileView.addContactsButton addTarget:self
                                           action:@selector(showAddContacts:)
                                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.profileView.contactsButton addTarget:self
                                        action:@selector(showContacts:)
                              forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightButtonAction:(UITapGestureRecognizer *)sender {
    if (self.isEditiing) {
        [self save];
    } else {
        [self startEditing];
    }
}

- (void)leftButtonAction:(UITapGestureRecognizer *)sender {
    if (self.isEditiing) {
        [self doneEditing];
    } else {
        [self.baseDelegate dismissViewController:self];
    }
}

- (void)startEditing {
    CGPoint point = self.containerView.contentOffset;
    point.x = self.view.frame.size.width;
    [self.containerView setContentOffset:point animated:YES];
    
    self.navbarView.leftButton.text = @"Back";
    self.navbarView.rightButton.text = @"Save";
    self.navbarView.titleLabel.text = @"Edit Profile";
    
    self.isEditiing = YES;
}

- (void)save {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    if (manager.profileAccount.type == ACCOUNTTYPE_EMAIL) {
        if (![self.editView.emailField.text isEqualToString:manager.profileAccount.emailAddress]) {
            [manager updateEmail:self.editView.emailField.text
                    withComplete:^(BOOL success, NSError *error) {
                        Account *profileAccount = [AppManager sharedInstance].accountManager.profileAccount;
                        profileAccount.displayName = self.editView.nameField.text;
                        profileAccount.phoneNumber = self.editView.phoneNumberField.text;
                        
                        [manager saveAccount:profileAccount
                                withComplete:^(BOOL success, NSError *error) {
                                    [self.profileView reload];
                                    [self.editView reload];
                    
                                    [self doneEditing];
                                }];
                    }];
        } else {
            Account *profileAccount = [AppManager sharedInstance].accountManager.profileAccount;
            profileAccount.displayName = self.editView.nameField.text;
            profileAccount.phoneNumber = self.editView.phoneNumberField.text;
            
            [manager saveAccount:profileAccount
                    withComplete:^(BOOL success, NSError *error) {
                        [self.profileView reload];
                        [self.editView reload];
                        
                        [self doneEditing];
                    }];
        }
    } else {
        Account *profileAccount = [AppManager sharedInstance].accountManager.profileAccount;
        profileAccount.displayName = self.editView.nameField.text;
        profileAccount.phoneNumber = self.editView.phoneNumberField.text;
        
        [manager saveAccount:profileAccount
                withComplete:^(BOOL success, NSError *error) {
                    [self.profileView reload];
                    [self.editView reload];
                    
                    [self doneEditing];
                }];
    }
}

- (void)doneEditing {
    CGPoint point = self.containerView.contentOffset;
    point.x = 0;
    [self.containerView setContentOffset:point animated:YES];
    
    self.navbarView.titleLabel.text = @"Profile";
    self.navbarView.leftButton.text = @"Close";
    self.navbarView.rightButton.text = @"Edit";

    self.isEditiing = NO;
}

- (void)signOutHandler:(UIButton *)sender {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    [manager signOut];
    [self.baseDelegate dismissViewController:self];
}


- (void)showAddContacts:(UIButton *)sender {
    AddContactsViewController *vc = [[AddContactsViewController alloc] init];
    [self.baseDelegate presentViewController:vc];
}

- (void)showContacts:(UIButton *)sender {
    ContactsViewControler *vc = [[ContactsViewControler alloc] init];
    [self.baseDelegate presentViewController:vc];
}

@end