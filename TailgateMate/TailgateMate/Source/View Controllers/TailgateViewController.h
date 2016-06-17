//
//  EventViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 5/4/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"

@interface EventViewController : BaseViewController

@property (nonatomic, weak) id<BaseViewControllerDelegate> baseViewControllerDelegate;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *lotNumberLabel;
@property (nonatomic, weak) IBOutlet UIButton *moreDtailsButton;
@property (nonatomic, weak) IBOutlet UIView *havesContainer;
@property (nonatomic, weak) IBOutlet UIView *needsContainer;

- (id)initWithEvent:(TailgateParty *)tailgateParty;

@end
