//
//  TimelineItemImageTableCell.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/17/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineItemImageTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *itemImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@property (nonatomic, weak) IBOutlet UIView *line1;
@property (nonatomic, weak) IBOutlet UIView *line2;
@property (nonatomic, weak) IBOutlet UIView *line3;

@property (nonatomic, weak) IBOutlet UIButton *flagButton;

+ (instancetype)instanceWithDefaultNib;
+ (CGFloat)heightForItem:(TimelineItem *)item;

- (void)populateWithItem:(TimelineItem *)item andTailgateParty:(TailgateParty *)party;
- (void)popluateWithImage:(UIImage *)image;
- (void)hasBeenFlagged:(void (^)(TimelineItem *item))handler;

@end
