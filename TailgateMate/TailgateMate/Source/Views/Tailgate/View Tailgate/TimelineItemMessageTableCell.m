//
//  TimelineItemMessageTableCell.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/12/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TimelineItemMessageTableCell.h"
#import "NSDate+Additions.h"

@implementation TimelineItemMessageTableCell

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TimelineItemMessageTableCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

+ (CGFloat)heightForItem:(TimelineItem *)item {
    CGFloat startingY = 10.0f;
    CGFloat height = startingY;
    CGFloat buffer = 11.0f;
    
    height += 20.0f + buffer;
    
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]};
        
    CGRect labelRect = [item.message boundingRectWithSize:CGSizeMake(304, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attrs
                                                  context:nil];
        
    height += labelRect.size.height + buffer;    
    height += 15.0f + 5.0f;
    
    return height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)populateWithTimelineItem:(TimelineItem *)item {
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
    
    CGRect frame = self.frame;
    frame.size.height = [TimelineItemMessageTableCell heightForItem:item];
    self.frame = frame;
    
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]};
        
    CGRect labelRect = [item.message boundingRectWithSize:CGSizeMake(304, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attrs
                                                  context:nil];
        
    frame = self.messageLabel.frame;
    frame.size.height = labelRect.size.height;
    frame.origin.y = self.line1.frame.origin.y + 6;
    self.messageLabel.frame = frame;
        
    frame = self.line2.frame;
    frame.origin.y = self.messageLabel.frame.size.height + self.messageLabel.frame.origin.y + 5.0f;
    self.line2.frame = frame;
        
    frame = self.timeLabel.frame;
    frame.origin.y = self.line2.frame.origin.y + self.line2.frame.size.height + 5.0f;
    self.timeLabel.frame = frame;
}

@end
