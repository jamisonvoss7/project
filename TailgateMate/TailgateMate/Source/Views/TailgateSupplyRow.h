//
//  TailgateSupplyRow.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TailgateSupplyRow : UIView

+ (instancetype)instanceFromDefaultNib;
- (void)setButtons:(NSArray *)buttons;

@end
