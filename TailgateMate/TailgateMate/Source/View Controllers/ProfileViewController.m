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


- (void)startEditing:(UIButton *)sender {
    CGPoint point = self.containerView.contentOffset;
    point.x = self.view.frame.size.width;
    [self.containerView setContentOffset:point animated:YES];
    
    self.navbarView.leftButton.text = @"Back";
    self.navbarView.rightButton.text = @"Save";
    self.navbarView.titleLabel.text = @"Edit Profile";
}

- (void)save:(UIButton *)sender {
    Account *account = [[Account alloc] init];
    account.firstName = self.editView.firstNameField.text;
    account.lastName = self.editView.lastNameField.text;
    account.emailAddress = self.editView.emailField.text;
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    [manager saveAccount:account withComplete:^(BOOL success, NSError *error) {
        [self.profileView reload];
        [self.editView reload];
        
        CGPoint point = self.containerView.contentOffset;
        point.x = 0;
        [self.containerView setContentOffset:point animated:YES];
        
        self.profileView.hidden = NO;
        self.editView.hidden = YES;
    }];
}

- (void)cancel:(UIButton *)sender {
    self.profileView.hidden = NO;
    self.editView.hidden = YES;

    [self.profileView reload];
    [self.editView reload];
}

- (void)close:(UIButton *)sender {
    [self.baseDelegate dismissViewController:self];
}

- (void)signOutHandler:(UIButton *)sender {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    [manager signOut];
    [self.baseDelegate dismissViewController:self];
}

- (void)closeView:(UITapGestureRecognizer *)sender {
    [self.baseDelegate dismissViewController:self];
}

- (void)showContacts:(UITapGestureRecognizer *)sender {
    AddContactsViewController *vc = [[AddContactsViewController alloc] init];
    [self.baseDelegate addViewController:vc];
}

@end
