//
//  LandingViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 5/19/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "LandingViewController.h"
#import "HomeMapViewController.h"
#import "ProfileViewController.h"
#import "AddTailgateViewController.h"
#import "LoginViewController.h"

@interface LandingViewController ()

@end

@implementation LandingViewController

- (id)init {
    self = [super initWithNibName:@"LandingViewController"
                           bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *hostTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostTapHandler:)];
    hostTap.numberOfTapsRequired = 1;
    [self.createTailgateView addGestureRecognizer:hostTap];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapHandler:)];
    viewTap.numberOfTapsRequired = 1;
    [self.viewMapView addGestureRecognizer:viewTap];
    
    [self.profileButton addTarget:self
                           action:@selector(viewProfile:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    self.profileButton.layer.cornerRadius = 15.0f;
    self.profileButton.layer.borderWidth = 3.0f;
    self.profileButton.layer.borderColor = [[UIColor whiteColor] CGColor];

    
    self.createTailgateView.layer.cornerRadius = 15.0f;
    self.createTailgateView.layer.borderWidth = 3.0f;
    self.createTailgateView.layer.borderColor = [[UIColor whiteColor] CGColor];

    self.viewMapView.layer.cornerRadius = 15.0f;
    self.viewMapView.layer.borderWidth = 3.0f;
    self.viewMapView.layer.borderColor = [[UIColor whiteColor] CGColor];    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    
    if (manager.isAuthenticated) {
        [self.profileButton setTitle:@"View Account" forState:UIControlStateNormal];
    } else {
        [self.profileButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    }
}

- (void)hostTapHandler:(UITapGestureRecognizer *)sender {
    AddTailgateViewController *vc = [[AddTailgateViewController alloc] init];
    [self.baseDelegate presentViewController:vc];
}

- (void)viewTapHandler:(UITapGestureRecognizer *)sender {
    HomeMapViewController *vc = [[HomeMapViewController alloc] init];
    [self.baseDelegate presentViewController:vc];
}

- (void)viewProfile:(UIButton *)sender {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    
    if (manager.isAuthenticated) {
        ProfileViewController *vc = [[ProfileViewController alloc] init];
        [self.baseDelegate presentViewController:vc];
    } else {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.baseDelegate presentViewController:vc];
    }
}

@end
