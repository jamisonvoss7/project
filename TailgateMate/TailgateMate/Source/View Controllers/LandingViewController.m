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
#import "AddEventViewController.h"

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

- (void)hostTapHandler:(UITapGestureRecognizer *)sender {
    AddEventViewController *vc = [[AddEventViewController alloc] init];
    vc.baseViewControllerDelegate = self.baseViewControllerDelegate;
    [self.baseViewControllerDelegate addViewController:vc];
}

- (void)viewTapHandler:(UITapGestureRecognizer *)sender {
    HomeMapViewController *vc = [[HomeMapViewController alloc] init];
    vc.baseViewControllerDelegate = self.baseViewControllerDelegate;
    [self.baseViewControllerDelegate addViewController:vc];
}

- (void)viewProfile:(UIButton *)sender {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.baseViewControllerDelegate = self.baseViewControllerDelegate;
    [self.baseViewControllerDelegate addViewController:vc];
}

@end