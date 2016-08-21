//
//  TailgateSupplyRow.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  TailgateSupplyRowDelegateProtocol <NSObject>
- (void)supplyAdded:(TailgateSupply *)supply;
- (void)supplyRemoved:(TailgateSupply *)supply;
@end

@interface TailgateSupplyRow : UIView

@property (nonatomic, weak) id<TailgateSupplyRowDelegateProtocol> delegate;

+ (instancetype)instanceFromDefaultNib;
- (void)setSupplies:(NSArray *)supplies;

@end
