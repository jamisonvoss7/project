//
//  ProfileView.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ProfileView.h"

@implementation ProfileView

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"ProfileView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor lightGrayColor];
    [self reload];
}

- (void)reload {
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
    
    self.nameLabel.text = account.displayName;
}

@end
