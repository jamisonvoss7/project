//
//  TailgateCreationTableViewCell.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TimelineItemCreationTableCell.h"
#import "NSDate+Additions.h"

@implementation TimelineItemCreationTableCell

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TimelineItemCreationTableCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)populateWithTimelineItem:(TimelineItem *)item {
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
@end
