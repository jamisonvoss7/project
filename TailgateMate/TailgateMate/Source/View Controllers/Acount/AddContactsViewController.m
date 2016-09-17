//
//  AddContactsViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 9/13/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddContactsViewController.h"
#import "AddContactsView.h"
#import "NavbarView.h"

@interface AddContactsViewController ()
@property (nonatomic) AddContactsView *addContactsView;
@property (nonatomic) NavbarView *navbarView;
@end

@implementation AddContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navbarView = [NavbarView instanceFromDefaultNib];
    self.navbarView.titleLabel.text = @"Contacts";
    self.navbarView.leftButton.text = @"Close";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeView:)];
    tap.numberOfTapsRequired = 1;
    [self.navbarView.leftButton addGestureRecognizer:tap];
    
    [self.view addSubview:self.navbarView];

    self.addContactsView = [AddContactsView instanceWithDefaultNib];
    [self.addContactsView becomesVisible];

    self.addContactsView.addContactsVCDelegate = self;
    
    CGRect frame = self.view.bounds;
    frame.origin.y = self.navbarView.frame.size.height;
    frame.size.height = frame.size.height - self.navbarView.frame.size.height;
    self.addContactsView.frame = frame;
    
    [self.view addSubview:self.addContactsView];
}

- (void)presentAViewController:(UIViewController *)viewController {
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

- (void)closeView:(UITapGestureRecognizer *)sender {
    [self.baseDelegate dismissViewController:self];
}

@end
