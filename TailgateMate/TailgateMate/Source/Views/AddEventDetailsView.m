//
//  AddEventDetailsView.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/10/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddEventDetailsView.h"

@implementation AddEventDetailsView
+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"AddEventDetailsView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
@end
