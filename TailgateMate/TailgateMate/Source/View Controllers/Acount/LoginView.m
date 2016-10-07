//
//  LoginViewController.m
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@end

@implementation LoginView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"LoginView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.facebbokButton addTarget:self
                            action:@selector(facebookButtonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.emailButton addTarget:self
                         action:@selector(signInButtonTapped:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.basicAccountButton addTarget:self
                                action:@selector(signUpButtonTapped:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton addTarget:self
                        action:@selector(backButtonTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.facebbokButton.layer.cornerRadius = 15.0f;
    self.emailButton.layer.cornerRadius = 15.0f;
    self.basicAccountButton.layer.cornerRadius = 15.0f;
    
    self.facebbokButton.layer.borderWidth = 3.0f;
    self.emailButton.layer.borderWidth = 3.0f;
    self.basicAccountButton.layer.borderWidth = 3.0f;
    
    self.facebbokButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.emailButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.basicAccountButton.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)facebookButtonAction:(UIButton *)sender {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    BaseViewController *vc = (BaseViewController *)self.flowDelegate;
    
    [self.flowDelegate beginFlowOfType:FlowTypeFacebook];
    
    [manager signInWithFacebookFromViewController:vc
                                   withCompletion:^(BOOL success, NSError *error) {
                                       if (success) {
                                           if ([AppManager sharedInstance].accountManager.profileAccount.userName.length == 0) {
                                               [self.flowDelegate showNextFlowStep:FlowStepAddUserName withObject:nil];
                                           } else {
                                               [self.flowDelegate showNextFlowStep:FlowStepDone withObject:nil];
                                           }
                                       } else if (error) {
                                           [self showAToast:@"An error occurred"];
                                       }
                                   }];
}

- (void)signUpButtonTapped:(UIButton *)sender {
    [self.flowDelegate beginFlowOfType:FlowTypeSignUp];
}

- (void)signInButtonTapped:(UIButton *)sender {
    [self.flowDelegate beginFlowOfType:FlowTypeSignIn];
}

- (void)backButtonTapped:(UIButton *)sender {
    [self.flowDelegate showNextFlowStep:FlowStepDone withObject:nil];
}


@end
