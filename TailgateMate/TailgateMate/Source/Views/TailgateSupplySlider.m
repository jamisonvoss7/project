//
//  TailgateSupplySlider.m
//  TailgateMate
//
//  Created by Jamison Voss on 5/4/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgateSupplySlider.h"

@implementation TailgateSupplyView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)instanceWitDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TailgateSupplyView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)populateWithTailgateSupply:(TailgateSupply *)supply {
    self.titleLabel.text = supply.name;
}

@end

@implementation TailgateSupplySlider
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
+ (instancetype)instanceWitDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TailgateSupplySlider" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}
- (void)setSupplies:(NSArray *)tailgateSupplies {
    CGSize contentSize = CGSizeMake(100 * tailgateSupplies.count, self.frame.size.height);
    self.scrollView.contentSize = contentSize;
    
    int i = 0;
    
    for (TailgateSupply *supply in tailgateSupplies) {
        TailgateSupplyView *view = [TailgateSupplyView instanceWitDefaultNib];
        [view populateWithTailgateSupply:supply];
        
        CGRect frame = view.frame;
        frame.origin.x = i * 100;
        view.frame = frame;
        
        [self.scrollView addSubview:view];
    }
}
@end
