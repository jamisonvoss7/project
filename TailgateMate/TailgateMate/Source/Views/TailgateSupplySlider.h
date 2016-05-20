//
//  TailgateSupplySlider.h
//  TailgateMate
//
//  Created by Jamison Voss on 5/4/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TailgateSupplyView : UIView
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
+ (instancetype)instanceWitDefaultNib;
- (void)populateWithTailgateSupply:(TailgateSupply *)supply;
@end

@interface TailgateSupplySlider : UIView

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
+ (instancetype)instanceWitDefaultNib;
- (void)setSupplies:(NSArray *)tailgateSupplies;

@end
