//
//  ContactCardView.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/27/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ContactCardView.h"
#import "ImageServiceProvider.h"

@implementation ContactCardView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"ContactCardView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 5.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(backgroundTapHandler:)];
    tap.numberOfTapsRequired = 1;
    [self.backgroundView addGestureRecognizer:tap];
    
    [self.addButton addTarget:self
                       action:@selector(addButtonTapHandler:)
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)setAccount:(Account *)account{
    _account = account;
    self.nameLabel.text = account.displayName;
    self.userNamelabel.text = account.userName;
    
    if (account.photoId) {
        [self.imageView showActivityIndicatorWithCurtain:YES];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@", account.userName, account.photoId];
        
        ImageServiceProvider *service = [[ImageServiceProvider alloc] init];
        [service getImageFromPath:path
                   withCompletion:^(UIImage *image, NSError *error) {
                       [self.imageView hideActivityIndicator];
                       self.imageView.image = image;
                   }];
    } else if (account.photoUrl) {
        [self.imageView showActivityIndicatorWithCurtain:YES];
        
        NSURL *url = [NSURL URLWithString:account.photoUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        self.imageView.image = img;
        
        [self.imageView hideActivityIndicator];
    } else {
        self.imageView.image = [UIImage imageNamed:@"default_profile"];
    }
}

- (void)addButtonTapHandler:(UIButton *)sender {
    if (self.delegate) {
        Contact *contact = [[Contact alloc] init];

        contact.userName = self.account.userName;
        contact.displayName = self.account.displayName;
        contact.phoneNumber = self.account.phoneNumber;
        contact.imageURL = self.account.photoUrl;
        contact.imageId = self.account.photoId;
        contact.emailAddress = self.account.emailAddress;
        
        [self.delegate cardView:self didAddWithContact:contact];
    }
}

- (void)backgroundTapHandler:(UITapGestureRecognizer *)sender {
    if (self.delegate) {
        [self.delegate cardView:self didAddWithContact:nil];
    }
}

@end
