//
//  TailgateSupplySlider.h
//  TailgateMate
//
//  Created by Jamison Voss on 5/4/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TailgateSupplySlider : UIView

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
+ (instancetype)instanceWitDefaultNib;
- (void)setSupplies:(NSArray *)tailgateSupplies;

@end
