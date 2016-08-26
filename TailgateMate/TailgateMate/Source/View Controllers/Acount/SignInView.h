//
//  SignInViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 3/22/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountFlowManagementViewController.h"

@interface SignInView : UIView

@property (nonatomic, weak) id<AccountFlowDelegate> flowDelegate;

@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *signInButton;
@property (nonatomic, weak) IBOutlet UIButton *backButton;

+ (instancetype)instanceWithDefaultNib;

@end
