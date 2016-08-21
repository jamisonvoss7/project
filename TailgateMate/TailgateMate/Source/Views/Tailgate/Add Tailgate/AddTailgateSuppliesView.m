//
//  AddTailgateSuppliesView.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddTailgateSuppliesView.h"
#import "TailgateSupplyRow.h"
#import "TailgateSupplyButton.h"

@interface AddTailgateSuppliesView () <TailgateSupplyRowDelegateProtocol>
@property (nonatomic, readwrite) NSMutableArray *selectedSupplies;
@property (nonatomic) NSArray *availableSupplies;
@end

@implementation AddTailgateSuppliesView

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"AddTailgateSuppliesView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.delegate = self;
    
    self.selectedSupplies = [[NSMutableArray alloc] init];
}

- (void)setTailgateSupplies:(NSArray *)supplies {
    self.availableSupplies = [NSArray arrayWithArray:supplies];
    [self loadViews];
}

- (void)loadViews {
    
    NSInteger numberOfRows = self.availableSupplies.count / 3 + 1;

    for (int i = 0; i < numberOfRows; i++) {
        NSInteger firstPos = i * 3;
        NSInteger secondPos = i * 3 + 1;
        NSInteger thirdPost = i * 3 + 2;
       
        NSMutableArray *supplies = [[NSMutableArray alloc] init];
        if (firstPos < self.availableSupplies.count) {
            TailgateSupply *supply1 = [self.availableSupplies objectAtIndex:firstPos];
            [supplies addObject:supply1];
        }
        if (secondPos < self.availableSupplies.count) {
            TailgateSupply *supply2 = [self.availableSupplies objectAtIndex:secondPos];
            [supplies addObject:supply2];
        }
        if (thirdPost < self.availableSupplies.count) {
            TailgateSupply *supply3 = [self.availableSupplies objectAtIndex:thirdPost];
            [supplies addObject:supply3];
        }
        
        TailgateSupplyRow *row = [TailgateSupplyRow instanceFromDefaultNib];
        [row setSupplies:supplies];
        row.delegate = self;
        
        CGRect frame = row.frame;
        frame.origin.x = 0;
        frame.origin.y = i * frame.size.height;
        frame.size.width = self.containerView.frame.size.width;
        row.frame = frame;
        
        [self.containerView addSubview:row];
        
        CGSize size = self.containerView.contentSize;
        size.height = row.frame.size.height + row.frame.origin.y;
        [self.containerView setContentSize:size];
    }
}

- (void)supplyAdded:(TailgateSupply *)supply {
    [self.selectedSupplies addObject:supply];
}

- (void)supplyRemoved:(TailgateSupply *)supply {
    [self.selectedSupplies removeObject:supply];
}

@end
