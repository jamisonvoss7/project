//
//  TimelineItemMessageTableCell.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/12/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TimelineItemMessageTableCell.h"
#import "NSDate+Additions.h"

@interface TimelineItemMessageTableCell ()
@property (nonatomic) TimelineItem *item;
@property (nonatomic, copy) void (^flagHandler)(TimelineItem *item);
@end

@implementation TimelineItemMessageTableCell

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TimelineItemMessageTableCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)hasBeenFlagged:(void (^)(TimelineItem *))handler{
    self.flagHandler = handler;
}

- (void)populateWithTimelineItem:(TimelineItem *)item {
    self.item = item;
    
    self.messageLabel.text = @"";
    self.timeLabel.text = @"";
    self.nameLabel.text = @"";
    
    self.nameLabel.text = item.userDisplayName;
    self.messageLabel.text = item.message;
    
    if ([item.tiemStamp withinOneMinute]) {
        self.timeLabel.text = @"Just Now";
    } else if ([item.tiemStamp withinOneHour]) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld min ago", (long)[item.tiemStamp minutesAgo]];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM d";
        self.timeLabel.text = [formatter stringFromDate:item.tiemStamp];
    }
}

- (void)flagTapHandler:(UIButton *)sender {
    if (self.flagHandler) {
        self.flagHandler(self.item);
    }
}

@end
