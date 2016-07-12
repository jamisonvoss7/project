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
    Account *account = [[Account alloc] init];
    account.emailAddress = self.editView.emailField.text;
    account.displayName = self.editView.nameField.text;
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    [manager saveAccount:account withComplete:^(BOOL success, NSError *error) {
        [self.profileView reload];
        [self.editView reload];
        
        [self doneEditing];
    }];
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


- (void)showContacts:(UITapGestureRecognizer *)sender {
    AddContactsViewController *vc = [[AddContactsViewController alloc] init];
    [self.baseDelegate addViewController:vc];
}

@end
