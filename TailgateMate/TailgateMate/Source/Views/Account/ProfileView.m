//
//  ProfileView.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ProfileView.h"
#import "ImageServiceProvider.h"

@implementation ProfileView

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"ProfileView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contactsButton.layer.cornerRadius = 15.0f;
    self.addContactsButton.layer.cornerRadius = 15.0f;
    self.addUserNameButton.layer.cornerRadius = 15.0f;
    
    self.contactsButton.layer.borderWidth = 3.0f;
    self.addContactsButton.layer.borderWidth = 3.0f;
    self.addUserNameButton.layer.borderWidth = 3.0f;
    
    self.contactsButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.addContactsButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.addUserNameButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self reload];
}

- (void)reload {
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
    
    if (account.photoId) {
        [self.profileImageView showActivityIndicatorWithCurtain:YES];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@", account.userName, account.photoId];
        
        ImageServiceProvider *service = [[ImageServiceProvider alloc] init];
        [service getImageFromPath:path
                   withCompletion:^(UIImage *image, NSError *error) {
                       [self.profileImageView hideActivityIndicator];
                       self.profileImageView.image = image;
                   }];
    } else if (account.photoUrl) {
        [self.profileImageView showActivityIndicatorWithCurtain:YES];
        
        NSURL *url = [NSURL URLWithString:account.photoUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];

        self.profileImageView.image = img;
        
        [self.profileImageView hideActivityIndicator];
    } else {
        self.profileImageView.image = [UIImage imageNamed:@"default_profile"];
    }
    
    self.nameLabel.text = account.displayName;
}

@end
