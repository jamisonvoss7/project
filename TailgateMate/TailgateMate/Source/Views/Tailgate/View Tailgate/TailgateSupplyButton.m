//
//  TailgateSupplyButton.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgateSupplyButton.h"

@interface TailgateSupplyButton ()
@property (nonatomic, assign) BOOL selected;
@property (nonatomic) TailgateSupply *supply;
@property (nonatomic, copy) void (^tapCallback)(TailgateSupply *, BOOL);
@end

@implementation TailgateSupplyButton

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TailgateSupplyButton" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selected = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)populateWithTailgateSupply:(TailgateSupply *)supply {
    self.titleLabel.text = supply.name;
    self.imageView.image = [UIImage imageNamed:supply.name];
    self.supply = supply;
}
- (void)tailgateSupplyStatusChangedWithComplete:(void (^)(TailgateSupply *, BOOL))handler {
    if (handler) {
        self.tapCallback = handler;
    }
}

- (void)tapHandler:(UITapGestureRecognizer *)sender {
    if (self.selected) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.delegate removedTailgateSupply:self.supply];
    } else {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:.7 alpha:.3];
        self.titleLabel.textColor = [UIColor lightTextColor];
        [self.delegate selectedTailgateSupply:self.supply];
    }
    
    self.selected = !self.selected;
    
    if (self.tapCallback) {
        self.tapCallback(self.supply, self.selected);
    }
}

@end
