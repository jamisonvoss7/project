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
@end

@implementation AddContactsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.addContactsView = [AddContactsView instanceWithDefaultNib];
    
    self.addContactsView.addContactsVCDelegate = self;
    
    CGRect frame = self.view.bounds;
    self.addContactsView.frame = frame;
    
    [self.addContactsView dismissHandler:^{
        [self closeView:nil];
    }];
    
    [self.view addSubview:self.addContactsView];
    
    [self.addContactsView becomesVisible];
}

- (void)presentAViewController:(UIViewController *)viewController {
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

- (void)closeView:(UITapGestureRecognizer *)sender {
    [self.baseDelegate dismissViewController:self];
}

- (void)tapHandler:(UITapGestureRecognizer *)tap {
    [self.addContactsView addAllAvailableContacts:nil];
}

@end
