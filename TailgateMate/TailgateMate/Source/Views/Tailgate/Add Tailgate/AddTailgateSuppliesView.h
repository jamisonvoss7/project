//
//  AddTailgateSuppliesView.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTailgateSuppliesView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *containerView;
@property (nonatomic, weak) IBOutlet UILabel *promptLabel;

@property (nonatomic, readonly) NSMutableArray *selectedSupplies;

+ (instancetype)instanceFromDefaultNib;
- (void)setTailgateSupplies:(NSArray *)supplies;

@end
