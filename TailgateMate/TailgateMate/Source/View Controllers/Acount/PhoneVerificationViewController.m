//
//  PhoneVerificationViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/24/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "PhoneVerificationViewController.h"
@import SinchVerification;
#import "AccountService.h"

@interface PhoneVerificationViewController ()
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, weak) id<SINVerification> verification;
@property (nonatomic, copy) void (^doneHandler)(void);
@end

@implementation PhoneVerificationViewController

- (instancetype)initWithPhonenumber:(NSString *)phonenumber {
    self = [super initWithNibName:@"PhoneVerificationViewController"
                           bundle:[NSBundle mainBundle]];
    if (self) {
        _phoneNumber = phonenumber;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(closeKeyboard)];
    closeTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:closeTap];
    
    
    self.verifyButton.layer.cornerRadius = 15.0f;
    self.verifyButton.layer.borderWidth = 3.0f;
    self.verifyButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.resendCodeButton.layer.cornerRadius = 15.0f;
    self.resendCodeButton.layer.borderWidth = 3.0f;
    self.resendCodeButton.layer.borderColor = [[UIColor whiteColor] CGColor];

    // Get user's current region by carrier info
    NSString* defaultRegion = [SINDeviceRegion currentCountryCode];
    NSError *parseError = nil;
    id<SINPhoneNumber> phoneNumber = [SINPhoneNumberUtil() parse:self.phoneNumber
                                                   defaultRegion:defaultRegion
                                                           error:&parseError];
    if (!phoneNumber){
        // Handle invalid user input
    }
    NSString *phoneNumberInE164 = [SINPhoneNumberUtil() formatNumber:phoneNumber
                                                              format:SINPhoneNumberFormatE164];
    id<SINVerification> verification = [SINVerification SMSVerificationWithApplicationKey:@"<application key>"
                                                                              phoneNumber:phoneNumberInE164];
    self.verification = verification; // retain the verification instance
    [verification initiateWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

- (IBAction)sendVerification:(id)sender {
    // User pressed a "Done" button after entering the code from the SMS.
    if (self.codeField.text.length == 0) {
        return;
    }
    
    [self.codeField resignFirstResponder];
    
    NSString* code = self.codeField.text;
    [self.verification verifyCode:code
                completionHandler:^(BOOL success, NSError* error) {
                    if (success) {
                        AccountService *service = [[AccountService alloc] init];
                        Account *account = [AppManager sharedInstance].accountManager.profileAccount;
                        account.phoneNumber = self.phoneNumber;
                        account.phoneNumberVerified = YES;
                        [service saveAccount:account
                                withComplete:^(BOOL success, NSError *error) {
                                    if (success) {
                                        self.doneHandler();
                                    } else {
                                        [self showToast:@"An error occurred"];
                                    }
                                }];
                    } else {
                        [self showErrorToast:@"Please try again"];
                    }
                }];
}

- (IBAction)resendCode:(id)sender {
    [self.verification initiateWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [self showToast:@"A new code has been sent"];
        }
    }];
}

- (void)onDone:(void (^)(void))handler {
    self.doneHandler = handler;
}

- (void)closeKeyboard {
    [self.codeField resignFirstResponder];
}


@end
