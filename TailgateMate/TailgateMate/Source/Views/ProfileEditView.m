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
    
    [self reload];
}

- (void)reload {
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
  
    self.nameField.text = account.displayName;
    if (account.type == ACCOUNTTYPE_FACEBOOK) {
        self.emailField.text = account.emailAddress;
    } else {
        self.emailField.text = account.credentials.userName;
    }
}

@end
