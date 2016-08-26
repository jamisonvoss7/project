//
//  AccountFlowManagementViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/24/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AccountFlowManagementViewController.h"
#import "LoginView.h"
#import "SignUpView.h"
#import "AddUserNameAndPhoneView.h"
#import "AddContactsView.h"
#import "SignInView.h"
#import "PhoneVerificationView.h"

@interface AccountFlowManagementViewController ()
@property (nonatomic, assign) FlowType flowType;

@property (nonatomic) LoginView *loginView;
@property (nonatomic) SignUpView *signUpView;
@property (nonatomic) AddUserNameAndPhoneView *userNamePhoneView;
@property (nonatomic) AddContactsView *contactsView;
@property (nonatomic) SignInView *signInView;
@property (nonatomic) PhoneVerificationView *phoneVerificationView;
@property (nonatomic) NSMutableArray *pages;
@property (nonatomic, assign) NSInteger pageCursor;

@end

@implementation AccountFlowManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.scrollEnabled = NO;
    
    self.loginView = [LoginView instanceWithDefaultNib];
    self.signUpView = [SignUpView instanceWithDefaultNib];
    self.userNamePhoneView = [AddUserNameAndPhoneView instanceWithDefualtNib];
    self.contactsView = [AddContactsView instanceWithDefaultNib];
    self.signInView = [SignInView instanceWithDefaultNib];
    self.phoneVerificationView = [PhoneVerificationView instanceWithDefaultNib];
    
    self.loginView.flowDelegate = self;
    self.signUpView.flowDelegate = self;
    self.signInView.flowDelegate = self;
    self.contactsView.flowDelegate = self;
    self.userNamePhoneView.flowDelegate = self;
    self.phoneVerificationView.flowDelegate = self;

    self.scrollView.contentSize = self.view.frame.size;
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    
    if ([manager isAuthenticated] &&
        manager.profileAccount.userName.length == 0) {
        self.userNamePhoneView.frame = self.scrollView.bounds;
        [self.scrollView addSubview:self.userNamePhoneView];
        self.pageCursor = 1;
        self.pages = [[NSMutableArray alloc] initWithObjects:self.userNamePhoneView, nil];
    } else {
        self.loginView.frame = self.scrollView.bounds;
        [self.scrollView addSubview:self.loginView];
        self.pageCursor = 1;
        self.pages = [[NSMutableArray alloc] initWithObjects:self.loginView, nil];
    }
}

- (void)beginFlowOfType:(FlowType)type {
    self.flowType = type;
    [self removeLastPage];

    if (type == FlowTypeSignUp) {
        [self addPageSizeToTheRight];
        
        CGRect frame = self.signUpView.frame;
        frame.origin.x = self.scrollView.contentSize.width - frame.size.width;
        self.signUpView.frame = frame;
        [self.scrollView addSubview:self.signUpView];
        
        [self.pages addObject:self.signUpView];
        
        [self scrollRight];
    } else if (type == FlowTypeSignIn) {
        
        [self addPageSizeToTheRight];
        
        CGRect frame = self.signInView.frame;
        frame.origin.x = self.scrollView.contentSize.width - frame.size.width;
        self.signInView.frame = frame;
        [self.scrollView addSubview:self.signInView];
        
        [self.pages addObject:self.signInView];
        
        [self scrollRight];
    } else if (type == FlowTypeSkip) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"hasSkipped"];
        [self showNextFlowStep:FlowStepDone withObject:nil];
    }
}

- (void)showNextFlowStep:(FlowSetp)type withObject:(id)object {
    if (type == FlowStepAddUserName) {
        [self addPageSizeToTheRight];
        
        CGRect frame = self.userNamePhoneView.frame;
        frame.origin.x = self.scrollView.contentSize.width - frame.size.width;
        self.userNamePhoneView.frame = frame;
        [self.scrollView addSubview:self.userNamePhoneView];

        [self.pages addObject:self.userNamePhoneView];
    } else if (type == FlowStepAddContacts) {
        [self addPageSizeToTheRight];
        
        CGRect frame = self.contactsView.frame;
        frame.origin.x = self.scrollView.contentSize.width - frame.size.width;
        self.contactsView.frame = frame;
        [self.scrollView addSubview:self.contactsView];
        
        [self.contactsView becomesVisible];
        
        [self.pages addObject:self.contactsView];
    } else if (type == FlowStepVerifyPhone) {
        [self addPageSizeToTheRight];
        
        CGRect frame = self.phoneVerificationView.frame;
        frame.origin.x = self.scrollView.contentSize.width - frame.size.width;
        self.phoneVerificationView.frame = frame;
        [self.scrollView addSubview:self.phoneVerificationView];
        
        self.phoneVerificationView.phoneNumber = object;
        
        [self.pages addObject:self.phoneVerificationView];
    } else if (type == FlowStepDone) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"pastFirstLaunch"];
        [self.baseDelegate dismissViewController:self];
        return;
    }
    
    [self scrollRight];
}

- (void)flowManagerGoBack {
    [self scrollLeft];
}

- (void)presentAViewController:(UIViewController *)controller {
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

- (void)addPageSizeToTheRight {
    CGSize size = self.scrollView.contentSize;
    size.width += self.view.frame.size.width;
    self.scrollView.contentSize = size;
}

- (void)scrollRight {
    if (self.pageCursor < self.pages.count) {
        CGPoint point = self.scrollView.contentOffset;
        point.x = point.x + self.view.frame.size.width;
        [self.scrollView setContentOffset:point animated:YES];
        
        self.pageCursor++;
    }
}

- (void)scrollLeft {
    if (self.pageCursor > 0) {
        CGPoint point = self.scrollView.contentOffset;
        point.x = point.x - self.view.frame.size.width;
        [self.scrollView setContentOffset:point animated:YES];
    
        self.pageCursor--;
    }
}

- (void)removeLastPage {
    if (self.pageCursor < self.pages.count) {
        [[self.pages objectAtIndex:1] removeFromSuperview];
        [self.pages removeLastObject];
        
        CGSize size = self.scrollView.contentSize;
        size.width -= self.view.frame.size.width;
        self.scrollView.contentSize = size;
    }
}

@end
