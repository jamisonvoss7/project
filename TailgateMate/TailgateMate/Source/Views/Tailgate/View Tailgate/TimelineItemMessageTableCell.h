//
//  TimelineItemMessageTableCell.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/12/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineItemMessageTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIView *line1;
@property (nonatomic, weak) IBOutlet UIView *line2;
@property (nonatomic, weak) IBOutlet UIButton *flagButton;

+ (instancetype)instanceWithDefaultNib;

- (void)populateWithTimelineItem:(TimelineItem *)item;
- (void)hasBeenFlagged:(void (^)(TimelineItem *item))handler;

@end
