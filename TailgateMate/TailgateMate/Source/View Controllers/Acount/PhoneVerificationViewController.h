//
//  PhoneVerificationViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/24/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"

@interface PhoneVerificationViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIButton *verifyButton;
@property (nonatomic, weak) IBOutlet UIButton *resendCodeButton;
@property (nonatomic, weak) IBOutlet UITextField *codeField;

- (instancetype)initWithPhonenumber:(NSString *)phonenumber;

- (IBAction)sendVerification:(id)sender;
- (IBAction)resendCode:(id)sender;

- (void)onDone:(void (^)(void))handler;

@end
