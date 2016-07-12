//
//  SignUpViewController.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationDelegate.h"
#import "BaseViewController.h"

@interface SignUpViewController : BaseViewController

@property (nonatomic, weak) id<AuthenticationDelegate> authDelegate;

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet UIButton *backbutton;



@end
