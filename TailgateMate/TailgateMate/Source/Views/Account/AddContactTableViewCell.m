//
//  AddContactTableViewCell.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddContactTableViewCell.h"

@implementation AddContactTableViewCell

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"AddContactTableViewCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}




@end
