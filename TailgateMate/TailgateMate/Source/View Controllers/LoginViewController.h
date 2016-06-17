//
//  LoginViewController.h
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationDelegate.h"
#import "BaseViewControllerDelegate.h"

@interface LoginViewController : UIViewController <AuthenticationDelegate>

@property (nonatomic, weak) id<BaseViewControllerDelegate> baseViewControllerDelegate;

@property (nonatomic, weak) IBOutlet UIButton *facebbokButton;
@property (nonatomic, weak) IBOutlet UIButton *twitterButton;
@property (nonatomic, weak) IBOutlet UIButton *emailButton;
@property (nonatomic, weak) IBOutlet UIButton *basicAccountButton;
@property (nonatomic, weak) IBOutlet UIButton *skipButton;

@end
