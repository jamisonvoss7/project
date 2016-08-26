//
//  LoginViewController.h
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountFlowManagementViewController.h"

@interface LoginView : UIView

@property (nonatomic, weak) id<AccountFlowDelegate> flowDelegate;

@property (nonatomic, weak) IBOutlet UIButton *facebbokButton;
@property (nonatomic, weak) IBOutlet UIButton *emailButton;
@property (nonatomic, weak) IBOutlet UIButton *basicAccountButton;
@property (nonatomic, weak) IBOutlet UIButton *skipButton;
@property (nonatomic, weak) IBOutlet UIButton *backButton;

+ (instancetype)instanceWithDefaultNib;

@end
