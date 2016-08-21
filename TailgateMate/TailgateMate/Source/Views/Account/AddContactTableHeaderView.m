//
//  AddContactTableHeaderView.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddContactTableHeaderView.h"

@implementation AddContactTableHeaderView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"AddContactTableHeaderView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
