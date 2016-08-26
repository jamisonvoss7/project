//
//  PhoneVerificationViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/24/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "PhoneVerificationView.h"
@import SinchVerification;
#import "AccountService.h"
#import "Batch.h"

@interface PhoneVerificationView ()
@property (nonatomic) id<SINVerification> verification;
@end

@implementation PhoneVerificationView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"PhoneVerificationView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(closeKeyboard)];
    closeTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:closeTap];

    self.verifyButton.layer.cornerRadius = 15.0f;
    self.verifyButton.layer.borderWidth = 3.0f;
    self.verifyButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.resendCodeButton.layer.cornerRadius = 15.0f;
    self.resendCodeButton.layer.borderWidth = 3.0f;
    self.resendCodeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
    
    if (self.flowDelegate) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    // Get user's current region by carrier info
    NSString* defaultRegion = [SINDeviceRegion currentCountryCode];
    NSError *parseError = nil;
    id<SINPhoneNumber> number = [SINPhoneNumberUtil() parse:_phoneNumber
                                                   defaultRegion:defaultRegion
                                                           error:&parseError];
    if (!phoneNumber){
        // Handle invalid user input
    }
    
    NSString *phoneNumberInE164 = [SINPhoneNumberUtil() formatNumber:number
                                                              format:SINPhoneNumberFormatE164];
    id<SINVerification> verification = [SINVerification SMSVerificationWithApplicationKey:@"fdee8f8f-aff7-4804-a484-576142f2355c"
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
                      
                        [service removeOtherAccountsPhoneNumber:self.phoneNumber
                                                   withComplete:^(BOOL success, NSError *error) {
                                                       if (success) {
                                                           [service saveAccount:account
                                                                   withComplete:^(BOOL success, NSError *error) {
                                                                       if (!error) {
                                                                           if (self.flowDelegate) {
                                                                               [self.flowDelegate showNextFlowStep:FlowStepAddContacts withObject:nil];
                                                                           } else if (self.profileDelegate) {
                                                                               [self.profileDelegate finishUpdatingPhone];
                                                                           }
                                                                       } else {
                                                                           [self showAToast:@"An error occurred"];
                                                                       }
                                                                   }];
                                                       } else {
                                                           [self showAToast:@"An error occurred"];
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
            [self showAToast:@"A new code has been sent"];
        }
    }];
}

- (void)closeKeyboard {
    [self.codeField resignFirstResponder];
}


@end
