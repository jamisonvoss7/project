//
//  AddTimeLineItemView.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"

@interface AddTimelineItemViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *postButton;
@property (nonatomic, weak) IBOutlet UIView *imageClickReceiver;

- (instancetype)initWithTailgateParty:(TailgateParty *)party;

@end
