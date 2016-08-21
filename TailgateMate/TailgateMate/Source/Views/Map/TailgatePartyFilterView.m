//
//  TailgatePartyFilterView.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/18/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgatePartyFilterView.h"

@interface TailgatePartyFilterView ()
@property (nonatomic) UIView *selectionView;
@property (nonatomic, readwrite) TailgatePartyFanType *currentType;
@end

@implementation TailgatePartyFilterView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TailgatePartyFilterView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.selectionView = [[UIView alloc] initWithFrame:self.homeSelectionView.frame];
    self.selectionView.backgroundColor = [UIColor clearColor];
    self.selectionView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.selectionView.layer.borderWidth = 1.0f;
    
    self.selectionView.hidden = YES;
    [self insertSubview:self.selectionView atIndex:0];
    
    UITapGestureRecognizer *homeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeSelection)];
    homeTap.numberOfTapsRequired = 1;
    [self.homeSelectionView addGestureRecognizer:homeTap];

    UITapGestureRecognizer *awayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(awaySelection)];
    awayTap.numberOfTapsRequired = 1;
    [self.awaySelectionView addGestureRecognizer:awayTap];

    UITapGestureRecognizer *bothTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bothSelection)];
    bothTap.numberOfTapsRequired = 1;
    [self.bothSelectionView addGestureRecognizer:bothTap];
}

- (void)homeSelection {
    if (self.currentType == TAILGATEPARTYFANTYPE_HOME) {
        [UIView animateWithDuration:.2 animations:^{
            self.selectionView.hidden = YES;
        } completion:^(BOOL finished) {
            self.currentType = nil;
            [self.delegate filderDidUpateToType:self.currentType];
        }];
    } else {
        [UIView animateWithDuration:.2 animations:^{
            if (self.selectionView.hidden) {
                self.selectionView.hidden = NO;
            } else {
                self.selectionView.center = self.homeSelectionView.center;
            }
        } completion:^(BOOL finished) {
            self.currentType = TAILGATEPARTYFANTYPE_HOME;
            [self.delegate filderDidUpateToType:self.currentType];
        }];
    }
}

- (void)awaySelection {
    if (self.currentType == TAILGATEPARTYFANTYPE_AWAY) {
        [UIView animateWithDuration:.2 animations:^{
            self.selectionView.hidden = YES;
        } completion:^(BOOL finished) {
            self.currentType = nil;
            [self.delegate filderDidUpateToType:self.currentType];
        }];
    
    } else {
        if (self.selectionView.hidden) {
            self.selectionView.center = self.awaySelectionView.center;
        }

        [UIView animateWithDuration:.2 animations:^{
            if (self.selectionView.hidden) {
                self.selectionView.hidden = NO;
            } else {
                self.selectionView.center = self.awaySelectionView.center;
            }
        } completion:^(BOOL finished) {
            self.currentType = TAILGATEPARTYFANTYPE_AWAY;
            [self.delegate filderDidUpateToType:self.currentType];
        }];
    }
}

- (void)bothSelection {
    if (self.currentType == TAILGATEPARTYFANTYPE_BOTH) {
        [UIView animateWithDuration:.2 animations:^{
            self.selectionView.hidden = YES;
        } completion:^(BOOL finished) {
            self.currentType = nil;
            [self.delegate filderDidUpateToType:self.currentType];
        }];
    } else {
        if (self.selectionView.hidden) {
            self.selectionView.center = self.bothSelectionView.center;
        }

        [UIView animateWithDuration:.2 animations:^{
            if (self.selectionView.hidden) {
                self.selectionView.hidden = NO;
            } else {
                self.selectionView.center = self.bothSelectionView.center;
            }
        } completion:^(BOOL finished) {
            self.currentType = TAILGATEPARTYFANTYPE_BOTH;
            [self.delegate filderDidUpateToType:self.currentType];
        }];
    }
}

@end
