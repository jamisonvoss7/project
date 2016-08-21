//
//  LoginViewController.h
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationDelegate.h"
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <AuthenticationDelegate>

@property (nonatomic, weak) IBOutlet UIButton *facebbokButton;
@property (nonatomic, weak) IBOutlet UIButton *twitterButton;
@property (nonatomic, weak) IBOutlet UIButton *emailButton;
@property (nonatomic, weak) IBOutlet UIButton *basicAccountButton;
@property (nonatomic, weak) IBOutlet UIButton *skipButton;

@end
