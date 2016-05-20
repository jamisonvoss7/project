//
//  Navbar.m
//  TailgateMate
//
//  Created by Jamison Voss on 5/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "Navbar.h"

@implementation Navbar

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"Navbar"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    
}
@end
