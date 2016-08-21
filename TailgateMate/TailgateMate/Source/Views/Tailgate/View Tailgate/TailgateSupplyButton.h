//
//  TailgateSupplyButton.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TailgateSupplyViewDelegate.h"

@interface TailgateSupplyButton : UIView

@property (nonatomic, weak) id<TailgateSupplyViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

+ (instancetype)instanceFromDefaultNib;
- (void)populateWithTailgateSupply:(TailgateSupply *)supply;
- (void)tailgateSupplyStatusChangedWithComplete:(void (^)(TailgateSupply *supply, BOOL selected))handler;

@end
