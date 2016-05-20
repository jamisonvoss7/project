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

@interface ProfileViewController ()
@property (nonatomic) ProfileView *profileView;
@property (nonatomic) ProfileEditView *editView;
@property (nonatomic) UIBarButtonItem *barButton;
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
    
    self.profileView = [ProfileView instanceFromDefaultNib];
    self.editView = [ProfileEditView instanceFromDefaultNib];
    
    [self.containerView addSubview:self.profileView];
    [self.containerView addSubview:self.editView];
    self.editView.hidden = YES;
    
    self.titleLabel.text = @"Profile";
    [self.leftButton setTitle:@"Close" forState:UIControlStateNormal];;
    [self.rightButton setTitle:@"Edit" forState:UIControlStateNormal];
    
    self.signoutButton.layer.cornerRadius = 15.0f;
    self.signoutButton.layer.borderWidth = 3.0f;
    self.signoutButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.leftButton addTarget:self
                        action:@selector(close:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton addTarget:self
                         action:@selector(startEditing:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.signoutButton addTarget:self
                           action:@selector(signOutHandler:)
                 forControlEvents:UIControlEventTouchUpInside];
}


- (void)startEditing:(UIButton *)sender {
    self.profileView.hidden = YES;
    self.editView.hidden = NO;
    
    [self.leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
    
    [self.leftButton addTarget:self
                        action:@selector(cancel:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton addTarget:self
                         action:@selector(save:)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)save:(UIButton *)sender {
    Account *account = [[Account alloc] init];
    account.firstName = self.editView.firstNameField.text;
    account.lastName = self.editView.lastNameField.text;
    account.emailAddress = self.editView.emailField.text;
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    [manager saveAccount:account withComplete:^(BOOL success, NSError *error) {
        self.profileView.hidden = NO;
        self.editView.hidden = YES;

        [self.profileView reload];
        [self.editView reload];
    }];
}

- (void)cancel:(UIButton *)sender {
    self.profileView.hidden = NO;
    self.editView.hidden = YES;

    [self.profileView reload];
    [self.editView reload];
}

- (void)close:(UIButton *)sender {
    [self.baseViewControllerDelegate dismissViewController:self];
}

- (void)signOutHandler:(UIButton *)sender {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    [manager signOut];
    [self.baseViewControllerDelegate dismissViewController:self];
}

@end
