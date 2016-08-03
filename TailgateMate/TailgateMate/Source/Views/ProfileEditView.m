//
//  ProfileEditView.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ProfileEditView.h"

@implementation ProfileEditView

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"ProfileEditView"
                                bundle:[NSBundle mainBundle]];
    
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.emailField.hidden = YES;
    
    self.backgroundColor = [UIColor lightGrayColor];

    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
    if ([[account.type description] isEqualToString:[ACCOUNTTYPE_EMAIL description]]) {
        self.emailField.hidden = NO;
    }
    
    [self reload];
}

- (void)reload {
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
  
    self.nameField.text = account.displayName;
    self.emailField.text = account.emailAddress;
    self.phoneNumberField.text = account.phoneNumber;
    self.userNameField.text = account.userName;
    
}

@end
