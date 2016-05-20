//
//  SignInViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 3/22/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationDelegate.h"
#import "BaseViewController.h"

@interface SignInViewController : BaseViewController

@property (nonatomic, weak) id<AuthenticationDelegate> authDelegate;

@property (nonatomic, weak) id<BaseViewControllerDelegate> baseViewControllerDelegate;

@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *signInButton;
@property (nonatomic, weak) IBOutlet UIButton *backButton;

@end
