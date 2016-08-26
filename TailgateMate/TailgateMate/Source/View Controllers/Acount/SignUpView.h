//
//  SignUpViewController.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountFlowManagementViewController.h"

@interface SignUpView : UIView

@property (nonatomic, weak) id<AccountFlowDelegate> flowDelegate;

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet UIButton *backbutton;

+ (instancetype)instanceWithDefaultNib;

@end
