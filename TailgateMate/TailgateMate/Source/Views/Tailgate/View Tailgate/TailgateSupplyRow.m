//
//  TailgateSupplyRow.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgateSupplyRow.h"
#import "TailgateSupplyButton.h"

@implementation TailgateSupplyRow

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TailgateSupplyRow"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSupplies:(NSArray *)supplies {
    
    void (^delegateCallback)(TailgateSupply *, BOOL) = ^(TailgateSupply *supply, BOOL selected) {
        if (selected) {
            [self.delegate supplyAdded:supply];
        } else {
            [self.delegate supplyRemoved:supply];
        }
    };
    
    if (supplies.count == 1) {
        TailgateSupply *supply = [supplies firstObject];
        TailgateSupplyButton *button = [TailgateSupplyButton instanceFromDefaultNib];
        [button populateWithTailgateSupply:supply];
        [button tailgateSupplyStatusChangedWithComplete:delegateCallback];
        
        button.frame = self.bounds;
        [self addSubview:button];
    } else if (supplies.count == 2) {
        TailgateSupply *supply1 = [supplies firstObject];
        TailgateSupply *supply2 = [supplies lastObject];

        TailgateSupplyButton *button1 = [TailgateSupplyButton instanceFromDefaultNib];
        TailgateSupplyButton *button2 = [TailgateSupplyButton instanceFromDefaultNib];
        [button1 populateWithTailgateSupply:supply1];
        [button2 populateWithTailgateSupply:supply2];
        
        CGRect frame = button1.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.height = self.frame.size.height;
        frame.size.width = self.frame.size.width / 2.0f;
        button1.frame = frame;
        
        frame.origin.x = self.frame.size.width / 2.0f;
        button2.frame = frame;
        
        [button1 tailgateSupplyStatusChangedWithComplete:delegateCallback];
        [button2 tailgateSupplyStatusChangedWithComplete:delegateCallback];
        
        [self addSubview:button1];
        [self addSubview:button2];
    } else if (supplies.count == 3) {
        TailgateSupply *supply1 = [supplies firstObject];
        TailgateSupply *supply2 = [supplies objectAtIndex:1];
        TailgateSupply *supply3 = [supplies lastObject];

        TailgateSupplyButton *button1 = [TailgateSupplyButton instanceFromDefaultNib];
        TailgateSupplyButton *button2 = [TailgateSupplyButton instanceFromDefaultNib];
        TailgateSupplyButton *button3 = [TailgateSupplyButton instanceFromDefaultNib];
        
        [button1 populateWithTailgateSupply:supply1];
        [button2 populateWithTailgateSupply:supply2];
        [button3 populateWithTailgateSupply:supply3];
        
        CGRect frame = button1.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.height = self.frame.size.height;
        frame.size.width = self.frame.size.width / 3.0f;
        button1.frame = frame;
        
        frame.origin.x = self.frame.size.width / 3.0f;
        button2.frame = frame;

        frame.origin.x = self.frame.size.width / 3.0f * 2.0f;
        button3.frame = frame;
        
        [button1 tailgateSupplyStatusChangedWithComplete:delegateCallback];
        [button2 tailgateSupplyStatusChangedWithComplete:delegateCallback];
        [button3 tailgateSupplyStatusChangedWithComplete:delegateCallback];

        [self addSubview:button1];
        [self addSubview:button2];
        [self addSubview:button3];
    }
}

@end
