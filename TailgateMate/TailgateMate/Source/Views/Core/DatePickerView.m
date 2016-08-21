//
//  DatePickerView.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/14/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"DatePickerView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGRect viewFrame = self.greyView.frame;
    viewFrame.size.height = self.frame.size.height - self.toolBar.frame.origin.y;
    self.greyView.frame = frame;
}

@end
