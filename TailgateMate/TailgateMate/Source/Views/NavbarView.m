//
//  Navbar.m
//  TailgateMate
//
//  Created by Jamison Voss on 5/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "NavbarView.h"

@implementation NavbarView

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"NavbarView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    self.leftButton.userInteractionEnabled = YES;
    self.rightButton.userInteractionEnabled = YES;
}
@end
