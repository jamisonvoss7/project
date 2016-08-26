//
//  PhoneVerificationViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/24/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AccountFlowManagementViewController.h"
#import "ProfileViewController.h"

@interface PhoneVerificationView : UIView

@property (nonatomic, weak) id<AccountFlowDelegate> flowDelegate;
@property (nonatomic, weak) id<ProfileEditDelegateProtocol> profileDelegate;
@property (nonatomic, weak) IBOutlet UIButton *verifyButton;
@property (nonatomic, weak) IBOutlet UIButton *resendCodeButton;
@property (nonatomic, weak) IBOutlet UITextField *codeField;

@property (nonatomic) NSString *phoneNumber;

+ (instancetype)instanceWithDefaultNib;

- (IBAction)sendVerification:(id)sender;
- (IBAction)resendCode:(id)sender;

@end
