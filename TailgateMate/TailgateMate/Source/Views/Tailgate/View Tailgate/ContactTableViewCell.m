//
//  ContactTableViewCell.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"ContactTableViewCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)populateWithContact:(Contact *)contact {
    self.contactNameLabel.text = contact.displayName;
    
    if (contact.imageURL.length > 0) {
        NSURL *url = [NSURL URLWithString:contact.imageURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        self.contactImageView.image = image;
    } else {
        self.contactImageView.image = [UIImage imageNamed:@"default_profile"];
    }
}

@end
