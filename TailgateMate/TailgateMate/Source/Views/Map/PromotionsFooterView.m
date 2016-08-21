//
//  PromotionsFooterView.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/20/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "PromotionsFooterView.h"

@implementation PromotionsFooterView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"PromotionsFooterView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

+ (CGFloat)heightForView {
    return 50.0f;
}

- (void)awakeFromNib {
    self.messageLabel.text = @"If you'd like to post a flyer or promotion here, contact us at pregame@gmail.com";
}

@end
