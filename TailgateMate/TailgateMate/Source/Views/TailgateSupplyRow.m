//
//  TailgateSupplyRow.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgateSupplyRow.h"

@implementation TailgateSupplyRow

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TailgateSupplyRow"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
   // self.backgroundColor = [UIColor whiteColor];
}

- (void)setButtons:(NSArray *)buttons {
    if (buttons.count == 1) {
        UIView *view = [buttons firstObject];
        view.frame = self.bounds;
        [self addSubview:view];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
//                                                         attribute:NSLayoutAttributeTop
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeTop
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
//                                                         attribute:NSLayoutAttributeBottom
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeBottom
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//    
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
//                                                         attribute:NSLayoutAttributeLeading
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeLeading
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//    
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
//                                                         attribute:NSLayoutAttributeTrailing
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeTrailing
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
    } else if (buttons.count == 2) {
        UIView *view1 = [buttons firstObject];
        UIView *view2 = [buttons lastObject];

        CGRect frame = view1.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.height = self.frame.size.height;
        frame.size.width = self.frame.size.width / 2.0f;
        view1.frame = frame;
        
        frame.origin.x = self.frame.size.width / 2.0f;
        view2.frame = frame;
        
        [self addSubview:view1];
        [self addSubview:view2];
        
        // =======================
        // View 1 Constraints
        // =======================

//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                         attribute:NSLayoutAttributeTop
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeTop
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                         attribute:NSLayoutAttributeBottom
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeBottom
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                         attribute:NSLayoutAttributeWidth
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:view2
//                                                         attribute:NSLayoutAttributeWidth
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                         attribute:NSLayoutAttributeTrailing
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:view2
//                                                         attribute:NSLayoutAttributeLeading
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        // =======================
//        // View 2 constraints
//        // =======================
//
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                         attribute:NSLayoutAttributeTop
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeTop
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                         attribute:NSLayoutAttributeBottom
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeBottom
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                         attribute:NSLayoutAttributeWidth
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:view1
//                                                         attribute:NSLayoutAttributeWidth
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                         attribute:NSLayoutAttributeLeading
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:view1
//                                                         attribute:NSLayoutAttributeTrailing
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];

    } else if (buttons.count == 3) {
        UIView *view1 = [buttons firstObject];
        UIView *view2 = [buttons objectAtIndex:1];
        UIView *view3 = [buttons lastObject];

        CGRect frame = view1.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.height = self.frame.size.height;
        frame.size.width = self.frame.size.width / 3.0f;
        view1.frame = frame;
        
        frame.origin.x = self.frame.size.width / 3.0f;
        view2.frame = frame;

        frame.origin.x = self.frame.size.width / 3.0f * 2.0f;
        view3.frame = frame;
        
        [self addSubview:view1];
        [self addSubview:view2];
        [self addSubview:view3];
        
        // =======================
        // View 1 Constraints
        // =======================

//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                         attribute:NSLayoutAttributeTop
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeTop
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                         attribute:NSLayoutAttributeBottom
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeBottom
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                         attribute:NSLayoutAttributeWidth
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:view2
//                                                         attribute:NSLayoutAttributeWidth
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                         attribute:NSLayoutAttributeTrailing
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:view2
//                                                         attribute:NSLayoutAttributeLeading
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        // =======================
//        // View 2 constraints
//        // =======================
//
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                         attribute:NSLayoutAttributeTop
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeTop
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                         attribute:NSLayoutAttributeBottom
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeBottom
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//                [self addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:view1
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                multiplier:1.0f
//                                                                  constant:0.0f]];
//        
//                [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                                 attribute:NSLayoutAttributeTrailing
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:view2
//                                                                 attribute:NSLayoutAttributeLeading
//                                                                multiplier:1.0f
//                                                                  constant:0.0f]];
//
//        // =======================
//        // View 3 constraints
//        // =======================
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view3
//                                                         attribute:NSLayoutAttributeTop
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeTop
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view3
//                                                         attribute:NSLayoutAttributeBottom
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeBottom
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                         attribute:NSLayoutAttributeWidth
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:view1
//                                                         attribute:NSLayoutAttributeWidth
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
//        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                         attribute:NSLayoutAttributeTrailing
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:view2
//                                                         attribute:NSLayoutAttributeLeading
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];

    }
}

@end
