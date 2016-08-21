//
//  TailgatePartyFilterView.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/18/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TailgatePartyFilterViewDelegateProtocol <NSObject>
- (void)filderDidUpateToType:(TailgatePartyFanType *)type;
@end

@interface TailgatePartyFilterView : UIView

@property (nonatomic, weak) id<TailgatePartyFilterViewDelegateProtocol> delegate;

@property (nonatomic, weak) IBOutlet UIView *homeSelectionView;
@property (nonatomic, weak) IBOutlet UIView *awaySelectionView;
@property (nonatomic, weak) IBOutlet UIView *bothSelectionView;
@property (nonatomic, readonly) TailgatePartyFanType *currentType;

+ (instancetype)instanceWithDefaultNib;


@end
