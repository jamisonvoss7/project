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
    
    NSURL *url = [NSURL URLWithString:account.photoUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];

    CGPoint point = self.profileImageView.center;

    CGRect frame = self.profileImageView.frame;
    frame.size.height = img.size.height;
    frame.size.width = img.size.width;
    self.profileImageView.frame = frame;
    
    self.profileImageView.center = point;
    
    self.profileImageView.image = img;
    
    self.nameLabel.text = account.displayName;
}

@end
