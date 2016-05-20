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
  
    self.firstNameField.text = account.firstName;
    self.lastNameField.text = account.lastName;
    self.emailField.text = account.emailAddress;
}

@end
